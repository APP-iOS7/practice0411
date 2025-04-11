//
//  WeatherService.swift
//  WeatherKitPractice
//
//  Created by NoelMacMini on 4/11/25.
//

import Foundation
import CoreLocation
import WeatherKit

class WeatherService {
    // 공유 인스턴스 생성
    static let shared = WeatherService()
    
    private init() {}
    
    // 날씨 정보를 가져오는 메서드
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        // WeatherKit의 WeatherService 인스턴스 생성
        let weatherService = WeatherKit.WeatherService.shared
        
        // 현재 날씨 가져오기
        let currentWeather = try await weatherService.weather(for: location)
        
        // 날씨 정보를 WeatherData 모델로 변환
        let weatherData = WeatherData(
            temperature: currentWeather.currentWeather.temperature.value,
            description: currentWeather.currentWeather.condition.description,
            humidity: currentWeather.currentWeather.humidity,
            windSpeed: currentWeather.currentWeather.wind.speed.value
        )
        
        return weatherData
    }
}
