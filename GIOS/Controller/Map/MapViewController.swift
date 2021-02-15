//
//  MapViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/15.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var returnButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segControl.setTitle("MyLocation", forSegmentAt: 0)
        self.segControl.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
        
        self.returnButton.setTitle("돌아가기", for: .normal)
        self.returnButton.addTarget(self, action: #selector(returnButtonAction), for: .touchUpInside)
        
        locationConfigure()
    }

    func locationConfigure() {
        locationManager.delegate = self
        // Map의 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Map의 위치 데이터를 사용자에게 요구
        locationManager.requestWhenInUseAuthorization()
        // Map의 위치 데이터 업데이트
        locationManager.startUpdatingLocation()
        // 위치보기설정
        self.map.showsUserLocation = true
    }
    
    // 위도, 경도, Span(영역 폭)을 입력받아 지도에 표시
    func getLocationData(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let location = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let region = MKCoordinateRegion(center: location, span: spanValue)
        
        self.map.setRegion(region, animated: true)
        return location
    }
    
    // 특정 위도와 경도에 핀 설치하고 핀에 타이틀과 서브 타이틀의 문자열 표시
    func setAnnotation(latitudeValue: CLLocationDegrees,
                       longitudeValue: CLLocationDegrees,
                       delta span :Double,
                       title strTitle: String,
                       subtitle strSubTitle:String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = getLocationData(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        self.map.addAnnotation(annotation)
    }
    
    // 위치 정보에서 국가, 지역, 도로를 추출하여 레이블 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Loading Map")
        let location = locations.last
        _ = getLocationData(latitudeValue: (location?.coordinate.latitude)!,
                            longitudeValue: (location?.coordinate.longitude)!,
                   delta: 0.01)
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {
            ( placemarks, error ) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address: String = ""
            
            if country != nil {
                address = country!
            }
            
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            print("Now Location : \(address)")
            print("Now Location : \(location!.coordinate)")
        })
        locationManager.stopUpdatingLocation()
    }
    
    @objc func returnButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func segmentControlAction(_ sender: UISegmentedControl) {
        print("Index : \(sender.selectedSegmentIndex)")
    }
}
