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
    print("📍 위치 정보 요청: \(location.coordinate.latitude), \(location.coordinate.longitude)") // 디버깅
    
    // WeatherKit의 WeatherService 인스턴스 생성
    let weatherService = WeatherKit.WeatherService.shared
    
    do {
      // 현재 날씨 가져오기
      print("☁️ 날씨 정보 요청 시작") // 디버깅
      let currentWeather = try await weatherService.weather(for: location)
      print("✅ 날씨 정보 요청 성공") // 디버깅
      
      // 날씨 정보를 출력해보기
      print("🌡️ 온도: \(currentWeather.currentWeather.temperature.value)") // 디버깅
      print("📝 설명: \(currentWeather.currentWeather.condition.description)") // 디버깅
      print("💧 습도: \(currentWeather.currentWeather.humidity)") // 디버깅
      print("💨 풍속: \(currentWeather.currentWeather.wind.speed.value)") // 디버깅
      
      // 날씨 정보를 WeatherData 모델로 변환
      let weatherData = WeatherData(
        temperature: currentWeather.currentWeather.temperature.value,
        description: currentWeather.currentWeather.condition.description,
        humidity: currentWeather.currentWeather.humidity,
        windSpeed: currentWeather.currentWeather.wind.speed.value
      )
      
      return weatherData
    } catch {
      // 디버깅: 오류 발생
      print("❌ 날씨 정보 요청 실패: \(error)")
      print("❌ 오류 상세: \(error.localizedDescription)")
      throw error
    }
  }
}
