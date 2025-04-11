//
//  LocationManager.swift
//  WeatherApp
//
//  Created by 박세라 on 4/11/25.
//

import Foundation
import CoreLocation

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    // 위치 권한 상태를 관리하는 변수
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // 현재 위치를 저장하는 변수
    @Published var currentLocation: CLLocation?
    
    override init() {
        super.init()
        
        // CLLocationManager 설정
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // 위치 권한을 요청하는 메소드
    func requestAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            manager.requestWhenInUseAuthorization()
        } else {
            print("위치 서비스가 비활성화되어 있습니다.")
        }
    }
    
    // 위치 업데이트가 성공적으로 이루어졌을 때 호출되는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else { return }
        
        // 첫 번째 위치를 받은 후에는 업데이트를 멈춥니다.
        if currentLocation == nil {
            currentLocation = newLocation
            manager.stopUpdatingLocation()  // 위치 업데이트 중지
        }
    }
    
    // 위치 업데이트가 실패했을 때 호출되는 메소드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 가져오기 실패:", error.localizedDescription)
    }

    // 위치 권한 변경이 있을 때 호출되는 메소드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    // 위치를 요청하는 메소드 (위치 업데이트 시작)
    func requestLocation() {
        manager.startUpdatingLocation()
    }
}
