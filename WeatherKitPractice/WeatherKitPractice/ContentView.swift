//
//  ContentView.swift
//  WeatherKitPractice
//
//  Created by NoelMacMini on 4/11/25.
//

import SwiftUI
import SwiftData
import CoreLocation

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @StateObject private var weatherViewModel = WeatherViewModel()
  @StateObject private var locationService = LocationService()
  
  var body: some View {
    VStack {
      // 헤더 섹션
      Text("TodayWeather")
        .font(.headline)
        .fontWeight(.bold)
        .padding()
      
      // 로딩중 or 날씨 데이터 없는 경우
      if weatherViewModel.isLoading {
        ProgressView()
          .scaleEffect(2.0)
          .padding()
        Text("날씨 정보를 불러오는 중...")
          .padding()
      }
        // 날씨 정보가 있는 경우
      else if let weather = weatherViewModel.weatherData {
        // 날씨 정보가 있는 경우
        VStack(spacing: 20) {
          Text("\(Int(weather.temperature))°C")
            .font(.largeTitle)
          
          Text(weather.description)
            .font(.title2)
          
          HStack(spacing: 40) {
            VStack {
              Text("습도")
                .font(.headline)
              Text("\(Int(weather.humidity*100))%")
                .font(.title3)
            }
            
            VStack {
              Text("풍속")
                .font(.headline)
              Text("\(Int(weather.windSpeed)) m/s")
                .font(.title3)
            }
          }
          .padding()
        }
        .padding()
      } else {
        // 날씨 데이터가 없는 경우
        Text("날씨 정보가 없습니다")
          .font(.title)
          .padding()
      }
      
      // 새로고침 버튼
      Button {
        Task {
          await fetchWeatherData()
        }
      } label: {
        Text("날씨 정보 새로고침")
          .font(.headline)
          .foregroundStyle(.white)
          .padding()
          .background(Color.blue)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .padding()
    }
    .padding()
    .onAppear {
      // 위치 권한 요청
      locationService.requestLocationPermission()
    }
    .onChange(of: locationService.currentLocation) { _, newLocation in
      if let location = newLocation {
        weatherViewModel.setLocation(location)
        Task {
          await fetchWeatherData()
        }
      }
    }
  }
  
  // 날씨 데이터 가져오기
  private func fetchWeatherData() async {
    await weatherViewModel.fetchWeather()
  }
}

#Preview {
  ContentView()
}
