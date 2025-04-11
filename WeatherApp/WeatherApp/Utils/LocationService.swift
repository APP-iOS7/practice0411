//
//  LocationService.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import Foundation
import CoreLocation

// MARK: - 위치 서비스 클래스
class LocationService: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        setupLocationManager()
        authorizationStatus = locationManager.authorizationStatus
    }
    
    // 위치 매니저 초기 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500
        
    }
    
    // 위치 권한
    func requestWhenInUseAuthorization() {
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
    
    // CLLocation 위치 반환
    func location(latitude: Double, longitude: Double) -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // 현재 위치 요청
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    
}

extension LocationService: CLLocationManagerDelegate {
    // 위치 업데이트 시 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    // 위치 업데이트 실패 시 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🔴 위치 업데이트 실패: \(error.localizedDescription)")
    }
    
    // 권한 상태 변경 시 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
}
