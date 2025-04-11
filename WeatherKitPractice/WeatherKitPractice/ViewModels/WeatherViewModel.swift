//
//  WeatherViewModel.swift
//  WeatherKitPractice
//
//  Created by NoelMacMini on 4/11/25.
//

import SwiftUI
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
  // MARK: - Properties
  @Published var weatherData: WeatherData? // 날씨 데이터
  @Published var isLoading = false
  @Published var error: Error?
  @Published var location: CLLocation?
  @Published var searchTest = ""
  
  private let weatherService = WeatherService.shared
  
  func fetchWeather() async {
    guard let location = location else {
      print("❌ 위치 정보가 없습니다")
      error = NSError(domain: "WeatherApp", code: 100, userInfo: [NSLocalizedDescriptionKey: "위치 정보가 없습니다."])
      return
    }
    
    print("🔄 날씨 정보 로딩 시작: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    isLoading = true
    error = nil
    
    do {
      weatherData = try await weatherService.fetchWeather(for: location)
      print("✅ 날씨 정보 로딩 완료")
      print("🌡️ 온도: \(weatherData?.temperature ?? 0)")
    } catch {
      self.error = error
      print("❌ 날씨 정보 로딩 실패: \(error)")
      print("❌ 오류 상세: \(error.localizedDescription)")
    }
    
    isLoading = false
  }
  
  // 현재 위치 설정
  func setLocation(_ location: CLLocation) {
    self.location = location
  }
  
  
}

