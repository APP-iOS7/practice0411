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
      error = NSError(domain: "WeatherApp", code: 100, userInfo: [NSLocalizedDescriptionKey: "위치 정보가 없습니다."])
      return
    }
    
    isLoading = true
    error = nil
    
    do {
      weatherData = try await weatherService.fetchWeather(for: location)
    } catch {
      self.error = error
      print("날씨 정보를 가져오는데 실패했습니다: \(error)")
    }
    
    isLoading = false
  }
  
  // 현재 위치 설정
  func setLocation(_ location: CLLocation) {
    self.location = location
  }
  
  
}

