//
//  WeatherData.swift
//  WeatherKitPractice
//
//  Created by NoelMacMini on 4/11/25.
//
import Foundation

struct WeatherData: Codable {
  let temperature: Double  // 섭씨 온도
  let description: String  // 날씨 설명
  let humidity: Double     // 습도
  let windSpeed: Double    // 풍속
}
