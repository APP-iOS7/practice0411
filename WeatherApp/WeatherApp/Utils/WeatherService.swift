//
//  WeatherService.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

enum WeatherServiceError: Error {
    case failedToFetchWeather
    case locationError
    case networkError
    
    var message: String {
        switch self {
        case .failedToFetchWeather:
            return "날씨 정보를 가져오는데 실패했습니다."
        case .locationError:
            return "위치 정보를 가져오는데 실패했습니다."
        case .networkError:
            return "네트워크 연결이 끊겼습니다."
        }
    }
}

// MARK: - 날씨 서비스 클래스
class WeatherService {
    
    static let shared = WeatherService()
    private let weatherService = WeatherKit.WeatherService()
    
    private init() {}
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        do {
            
            let weather = try await weatherService.weather(for: location)
            let currentWeather = weather.currentWeather
            
            // WeatherData 데이터로 반환
            return WeatherData(temperature: currentWeather.temperature.value,
                               description: currentWeather.condition.description,
                               humidity: currentWeather.humidity,
                               windSpeed: currentWeather.wind.speed)
        } catch {
            print("🔴 날씨 정보 가져오기 실패: \(error.localizedDescription)")
            throw WeatherServiceError.failedToFetchWeather
        }
}
