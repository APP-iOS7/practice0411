//
//  ContentView.swift
//  WeatherCombine
//
//  Created by 멘태 on 4/11/25.
//

import SwiftUI
import Combine
import WeatherKit

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    private let locationService = LocationService.shared

    var body: some View {
        VStack {
            if let weather = viewModel.weather {
                Text("기온: \(weather.temperature)")
                Text("습도: \(weather.humidity)")
                Text("풍속: \(weather.windSpeed)")
                Text("\(weather.description)")
            } else {
                Text("날씨 정보 로딩중...")
            }
        }
        .padding()
        .onAppear {
            locationService.locationManager.requestWhenInUseAuthorization()
            if let location = locationService.currentLocation {
                viewModel.fetchWeather(location: location)
            }
        }
    }
}

#Preview {
    ContentView()
}
