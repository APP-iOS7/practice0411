//
//  WeatherData.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import Foundation

// MARK: - 날씨 데이터 모델
struct WeatherData: Codable {
    let temperature: Double // 섭씨 온도
    let description: String // 날씨 설명
    let humidity: Double // 습도
    let windSpeed: Measurement<UnitSpeed> // 풍속
}
