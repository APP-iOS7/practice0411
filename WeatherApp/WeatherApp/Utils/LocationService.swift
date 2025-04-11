//
//  LocationService.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import Foundation
import CoreLocation

// MARK: - 위치 서비스 클래스
class LocationService: NSObject {
    
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    
    weak var delegate: (any CLLocationManagerDelegate)?
    
    private var currentLocation: CLLocation?
    
    override init() {
        super.init()
        setupLocationManager()
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
    
    func location(latitude: Double, longitude: Double) -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

// MARK: - 위치 서비스 클래스 CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
