//
//  CameraController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/14.
//

import UIKit
import Foundation
import AVFoundation
import MetalKit

class CameraController : UIViewController {
    // Defined
    // 캡쳐 세션 정의
    var session: AVCaptureSession?
    // 캡쳐 장치 정의
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    // 장치 입력 구성
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var backCameraInput: AVCaptureDeviceInput?
    // 사진 촬영 정의
    var photoOutput: AVCapturePhotoOutput?
    // 카메라 화면 보기 정의
    var previewLayer: AVCaptureVideoPreviewLayer?
    var previewLayerMetal: MTKView?
    // 카메라 플래시
    var flashMode = AVCaptureDevice.FlashMode.off
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    // Defined
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CameraController {
    func prepare(completeHandler: @escaping ( Error? ) -> Void) {
        // Create Capture Session
        func createCaptureSession() {
            self.session = AVCaptureSession()
        }
        
        // Device Search for Camera
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            let cameras = session.devices.compactMap { $0 }
            
            guard !cameras.isEmpty else {
                throw CameraControllerError.noCameraAvailable
            }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.backCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        // Connect to Camera Device
        func configureDeviceInput() throws {
            guard let session = self.session else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            if let backCamera = self.backCamera {
                self.backCameraInput = try AVCaptureDeviceInput(device: backCamera)
                
                if session.canAddInput(self.backCameraInput!) {
                    session.addInput(self.backCameraInput!)
                }
                self.currentCameraPosition = .back
            } else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if session.canAddInput(self.frontCameraInput!) {
                    session.addInput(self.frontCameraInput!)
                }
                self.currentCameraPosition = .front
            } else {
                throw CameraControllerError.noCameraAvailable
            }
        }
        
        // Define to Camera Output
        func configurePhotoOutput() throws {
            guard let session = self.session else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if session.canAddOutput(self.photoOutput!) {
                session.addOutput(self.photoOutput!)
            }
            
            session.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInput()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completeHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completeHandler(nil)
            }
        }
    }
    
    // Camera Preview
    func displayPreview(on view: UIView) throws {
        guard let session = self.session, session.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        session.sessionPreset = .hd1920x1080
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        
        // 프리뷰가 Margin 100만큼 내려와 있으므로 view.frame을 하게되면 프리뷰 또한 100만큼 내려감
        // 프리뷰 프레임의 시작 좌표는 추가되어지는 뷰의 기준으로 0,0에서 시작되게 만들어야함.
//        self.previewLayer?.frame = view.frame
        self.previewLayer?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: UIScreen.main.bounds.height)
    }
    
    // Switching Camera
    func switchCameras() throws {
        guard let session = self.session, session.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        session.beginConfiguration()
        
        func switchToFrontCamera() throws {
            guard let backCameraInput = self.backCameraInput, let frontCamera = self.frontCamera,
                  session.inputs.contains(backCameraInput) else {
                throw CameraControllerError.invalidOperation
            }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            session.removeInput(backCameraInput)
            
            if session.canAddInput(self.frontCameraInput!) {
                session.addInput(self.frontCameraInput!)
                self.currentCameraPosition = .front
            } else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        func switchToBackCamera() throws {
            guard let frontCameraInput = self.frontCameraInput, let backCamera = self.backCamera,
                  session.inputs.contains(frontCameraInput) else {
                throw CameraControllerError.invalidOperation
            }
            
            self.backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            
            session.removeInput(frontCameraInput)
            
            if session.canAddInput(self.backCameraInput!) {
                session.addInput(self.backCameraInput!)
                self.currentCameraPosition = .back
            } else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToBackCamera()
        case .back:
            try switchToFrontCamera()
        case .none:
            throw CameraControllerError.captureSessionIsMissing
        }
        
        session.commitConfiguration()
    }
    
    // Fuction to capture Camera Image
    func captureImage(completion: @escaping ( UIImage?, Error? ) -> Void) {
        guard let session = self.session, session.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            self.photoCaptureCompletionBlock?(nil, error)
        } else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil) {
            let image = UIImage(data: data)
            self.photoCaptureCompletionBlock?(image, nil)
        } else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}

extension CameraController {
    // 예상할 수 있는 에러 정의
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCameraAvailable
        case unknown
    }

    public enum CameraPosition {
        case front
        case back
    }
}
