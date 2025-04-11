//
//  ContentView.swift
//  WeatherApp
//
//  Created by NO SEONGGYEONG on 4/11/25.
//

import SwiftUI
import SwiftData

/// 날씨 테스트 데이터
enum WeatherCondition: String {
    case clear
    case rainy
    case cloudy
    case snowy
}


struct ContentView: View {
    // 데모 데이터
    /// 섭씨 온도
    var temperature: Double = 24.0
    
    /// 날씨 설명
    var description: String = "맑음"
    
    /// 습도
    var humdity: Double = 70
    
    /// 풍속
    var windSpeed: Double = 39
    
    /// 날씨에 맞는 옷차림
    var clothes: String = "점퍼"
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Label("",systemImage: "sun.max.fill")
                    .font(.largeTitle)
                Text("\(temperature, specifier: "%.1f") °C")
                    .font(.largeTitle)
                    .padding(.trailing, 10)
                Text(description)
                    .font(.largeTitle)
            }
            Spacer()
            
            HStack {
                Text("습도: \(humdity, specifier: "%.1f") %")
                    .font(.title)
            }
            Spacer()
            
            HStack {
                Text("풍속: \(windSpeed, specifier: "%.1f") m/s")
                    .font(.title)
            }
            Spacer()
            
            HStack {
                Text("추천 옷차림: \(clothes)")
                    .font(.title)
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
