//
//  LocationDataManager.swift
//  WeatherCombine
//
//  Created by 멘태 on 4/11/25.
//

import CoreLocation
import WeatherKit

final class LocationDataManager: NSObject, CLLocationManagerDelegate {
    static let shared: LocationDataManager = LocationDataManager()
    var locationManager: CLLocationManager = CLLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            break
        case .restricted, .denied:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.first else {
            debugPrint("[Error] location 언래핑 에러")
            return
        }
        
        debugPrint(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        debugPrint("[Error] 위치 정보 조회 실패: \(error.localizedDescription)")
    }
}
