//
//  LocationService.swift
//  WeatherKitPractice
//
//  Created by NoelMacMini on 4/11/25.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject {
    // 위치 관리자
    private let locationManager = CLLocationManager()
    
    // 현재 위치
    @Published var currentLocation: CLLocation?
    
    // 위치 권한 상태
    @Published var authorizationStatus: CLAuthorizationStatus
    
    // 위치 오류
    @Published var locationError: Error?
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // 위치 권한 요청
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // 위치 업데이트 시작
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // 위치 업데이트 중지
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // 위치 정보 한번만 요청
    func requestLocation() {
        locationManager.requestLocation()
    }
}

// LocationManager 델리게이트 구현
extension LocationService: CLLocationManagerDelegate {
    // 위치 권한 상태 변경
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // 권한이 허용되면 위치 정보 요청
            manager.requestLocation()
        case .denied, .restricted:
            // 권한이 거부되면 오류 설정
            locationError = NSError(domain: "LocationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "위치 접근 권한이 필요합니다."])
        case .notDetermined:
            // 결정되지 않은 상태면 권한 요청
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    // 위치 정보 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            locationError = nil
        }
    }
    
    // 위치 오류 처리
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
}
