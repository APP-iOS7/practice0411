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
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500
        
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func location(latitude: Double, longitude: Double) -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

// MARK: - 위치 서비스 클래스 CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
}
