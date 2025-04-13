//
//  LocationService.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//
// https://yahoth.tistory.com/19

import Foundation
import CoreLocation
import SwiftUI

class LocationService: NSObject {
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func setCurrentCLLocation() -> CLLocation? {
        return locationManager.location
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            // 위치 정보 사용이 거부된 경우
            showLocationPermissionDeniedAlert()
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .authorizedAlways:
            print("authorizedAlways")
        @unknown default:
            print("unknown")
        }
    }
    
    // 위치 권한 거부 알림 다이얼로그 표시 메서드
    func showLocationPermissionDeniedAlert() {
        // SwiftUI에서 앱 설정 화면 이동
        // present -> UIViewController의 메서드이므로 아래 코드 사용
        // .alert() modifier 는 설정으로 이동이 제한적임.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let alertController = UIAlertController(
            title: "위치 정보 권한 필요",
            message: "이 앱의 기능을 사용하기 위해서는 위치 정보 접근 권한이 필요합니다. 설정에서 위치 접근 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        // 앱 설정 페이지로 이동하는 메서드 ( 시뮬레이터에서는 동작 안함 )
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        rootVC.present(alertController, animated: true, completion: nil)
    }
}
