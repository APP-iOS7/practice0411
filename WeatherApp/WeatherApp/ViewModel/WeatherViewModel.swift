//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import Foundation
import CoreLocation
import WeatherKit

enum APIError: Error, LocalizedError {
    case permissionDenied
    case unknownError
    case typeDenied
    case rangeError
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return WeatherError.permissionDenied.errorDescription
        case .unknownError: return "알 수 없는 오류"
        case .typeDenied: return "올바른 타입이 아닙니다."
        case .rangeError: return "위도 경도의 올바른 범위가 아닙니다."

        }
    }
}

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var location: CLLocation = CLLocation.init()
    
    func fetchWeather() async {
        do {
            isLoading = true
            let locationService = LocationService()
            locationService.requestLocation()
            location = locationService.setCurrentCLLocation()
            try await Task.sleep(nanoseconds: 500_000_000)
            weather = try await WeatherService.fetchWeather(for: self.location)
            isLoading = false
        } catch {
            debugPrint("날씨 정보 가져오기 실패: \(error)")
        }
    }
    
    func fetchCustomLocationWeather(_ latitude: String, _ longitude: String) async {
        do {
            guard let latDouble = Double(latitude), let longDouble = Double(longitude) else {
                throw APIError.typeDenied
            }
            
            guard latDouble >= -90, latDouble <= 90, longDouble >= -180, longDouble <= 180 else {
                throw APIError.rangeError
            }

            isLoading = true
            let customLocation = CLLocationCoordinate2D(latitude: latDouble, longitude: longDouble)
            location = CLLocation(latitude: customLocation.latitude, longitude: customLocation.longitude)
            weather = try await WeatherService.fetchWeather(for: self.location)
            isLoading = false
        } catch let error as APIError {
            self.error = error
            debugPrint(error.localizedDescription)
        } catch {
            self.error = error
            debugPrint("예상치 못한 오류 \(error)")
        }
    }
    
    func resetWeather() {
        weather = WeatherData.empty
    }
    
}
