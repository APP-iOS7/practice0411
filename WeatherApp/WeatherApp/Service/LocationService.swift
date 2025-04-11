//
//  LocationService.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//
// https://yahoth.tistory.com/19

import Foundation
import CoreLocation

class LocationService: NSObject {
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
        debugPrint("\(String(describing: locationManager.location?.coordinate.latitude))")
        debugPrint("\(String(describing: locationManager.location?.coordinate.longitude))")
    }
    
    func setCurrentCLLocation() -> CLLocation {
        return locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
