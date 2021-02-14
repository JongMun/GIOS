//
//  CameraViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/14.
//

import UIKit
import Photos
import AVFoundation

class CameraViewController: UIViewController {
    // Defined
    let cameraController = CameraController()
    
    // User Interface View
    @IBOutlet fileprivate var topPanel: UIView!
    @IBOutlet fileprivate var bottomPanel: UIView!
    @IBOutlet fileprivate var previewView: UIView!
    @IBOutlet fileprivate var albumImage: UIImageView?
    
    // User Interface Function
    let toggleCameraButton: CustomCameraButton = CustomCameraButton()
    let toggleFlashButton: CustomCameraButton = CustomCameraButton()
    let albumButton: CustomCameraButton = CustomCameraButton()
    let filterButton: CustomCameraButton = CustomCameraButton()
    let captureButton: CustomCameraShutterButton = CustomCameraShutterButton()
    
    // Prepare Filtering Panel
    fileprivate var filterPanel: UIView?
    fileprivate var collectionView: UICollectionView?
    // Defined
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        functionButtonInit()
        
        getOnePhoto()
        configureCameraController()
        addTapGetureAction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func getOnePhoto() {
        var imageArray = [UIImage]()

        let manager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                manager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFill, options: options) {
                    (image, error) in
                    imageArray.append(image!)
                }
            }
            imageArray.reverse()
            
            DispatchQueue.main.async {
                self.albumButton.setImage(imageArray[0], for: .normal)
            }
        } else {
            print("You got no photos!")
        }
    }
    
    // 커스텀 버튼 UI 뿌리기
    func functionButtonInit() {
        // 카메라 토글 버튼
        self.topPanel.addSubview(toggleCameraButton)
        toggleCameraButton.translatesAutoresizingMaskIntoConstraints = false
        toggleCameraButton.leftAnchor.constraint(equalTo: topPanel.leftAnchor, constant: 30).isActive = true
        toggleCameraButton.bottomAnchor.constraint(equalTo: topPanel.bottomAnchor, constant: -30).isActive = true
        toggleCameraButton.setImage(UIImage(named: "rotation"), for: .normal)
        toggleCameraButton.imageView?.contentMode = .scaleAspectFit
        
        // 플레시 토글 버튼
        self.topPanel.addSubview(toggleFlashButton)
        toggleFlashButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFlashButton.rightAnchor.constraint(equalTo: topPanel.rightAnchor, constant: -30).isActive = true
        toggleFlashButton.bottomAnchor.constraint(equalTo: topPanel.bottomAnchor, constant: -30).isActive = true
        toggleFlashButton.setImage(UIImage(named: "flashon"), for: .normal)
        toggleFlashButton.imageView?.contentMode = .scaleAspectFit
        
        // 사진 앨범 버튼
        self.bottomPanel.addSubview(albumButton)
        albumButton.translatesAutoresizingMaskIntoConstraints = false
        albumButton.leftAnchor.constraint(equalTo: bottomPanel.leftAnchor, constant: 30).isActive = true
        albumButton.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 30).isActive = true
        albumButton.setImage(UIImage(named: "image"), for: .normal)
        albumButton.imageView?.contentMode = .scaleAspectFill
        
        // 카메라 필터 버튼
        self.bottomPanel.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.rightAnchor.constraint(equalTo: bottomPanel.rightAnchor, constant: -30).isActive = true
        filterButton.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 30).isActive = true
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        
        // 카메라 셔터 버튼
        self.bottomPanel.addSubview(captureButton)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 30).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor).isActive = true
        captureButton.setImage(UIImage(named: "shutter"), for: .normal)
        captureButton.imageView?.contentMode = .scaleAspectFit
    }
    
    // 카메라 기능 정의, 시작
    func configureCameraController() {
        cameraController.prepare {
            (error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }
    
    // 버튼 외 탭 액션 연결
    func addTapGetureAction() {
        // 카메라 전환 이벤트 연결
        toggleCameraButton.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        
        // 플래시 토글 이벤트 연결
        toggleFlashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        
        // 사진앨범 이벤트 연결
        albumButton.addTarget(self, action: #selector(showLibrary), for: .touchUpInside)
        
        // 사진촬영 이벤트 연결
        captureButton.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
    }
    
    // 카메라 전환 이벤트 액션
    @objc func toggleCamera() {
        do {
            try cameraController.switchCameras()
        } catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            cameraController.flashMode = .off
        case .some(.back):
            cameraController.flashMode = .off
        case .none:
            return
        }
    }
    
    // 플래시 토글 이벤트 액션
    @objc func toggleFlash() {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(UIImage(named: "flashoff"), for: .normal)
        } else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(UIImage(named: "flashon"), for: .normal)
        }
    }
    
    // 앨범 이미지 뷰 클릭 액션
    @objc func showLibrary() {
        guard let cameraView = self.storyboard?.instantiateViewController(identifier: "PhotoCollection") else {
            return
        }
        self.present(cameraView, animated: true)
    }
    
    // 사진촬영 이벤트 액션
    @objc func takePicture() {
        DispatchQueue.main.async {
            self.cameraController.captureImage(completion: {
                (image, error) in
                guard let image = image else {
                    print(error ?? "Image Capture Error")
                    return
                }
                // Photokit 사용 이미지 저장
                try? PHPhotoLibrary.shared().performChangesAndWait {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                    // 앨범 뷰 이미지 수시로 교체
                    self.albumButton.setImage(image, for: .normal)
                }
            })
        }
    }
}
