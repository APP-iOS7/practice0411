//
//  Constants.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import Foundation

enum Constants {
    enum WeatherIcons {
        // 날씨 상세 설명에 따라 아이콘 변경
        static func iconFame(for description: String) -> String {
            let lowercased = description.lowercased()
            
            if lowercased.contains("맑음") || lowercased.contains("clear") {
                return "sun.max.fill"
            } else if lowercased.contains("구름") || lowercased.contains("cloud") {
                return "cloud.fill"
            } else if lowercased.contains("비") || lowercased.contains("rain") {
                return "cloud.rain.fill"
            } else if lowercased.contains("눈") || lowercased.contains("snow") {
                return "cloud.snow.fill"
            } else if lowercased.contains("안개") || lowercased.contains("fog") {
                return "cloud.fog.fill"
            } else if lowercased.contains("번개") || lowercased.contains("thunder") {
                return "cloud.bolt.fill"
            } else {
                return "thermometer"
            }
        }
    }
    
    // 날씨 상세 설명 영어 -> 한국어로 번역
    enum WeatherTranslation {
        static func translate(for description: String) -> String {
            let lowercased = description.lowercased()
            
            if lowercased.contains("clear") {
                return "맑음"
            } else if lowercased.contains("cloudy") || lowercased.contains("clouds") {
                return "구름 많음"
            } else if lowercased.contains("overcast") {
                return "흐림"
            } else if lowercased.contains("rain") {
                return "비"
            } else if lowercased.contains("drizzle") {
                return "이슬비"
            } else if lowercased.contains("snow") {
                return "눈"
            } else if lowercased.contains("fog") || lowercased.contains("mist") {
                return "안개"
            } else if lowercased.contains("thunder") || lowercased.contains("lightning") {
                return "번개"
            } else {
                return description // 번역할 수 없는 경우 원문 반환
            }
        }
    }
}
