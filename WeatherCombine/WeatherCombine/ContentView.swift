//
//  ContentView.swift
//  WeatherCombine
//
//  Created by 멘태 on 4/11/25.
//

import SwiftUI
import Combine
import CoreLocation
import WeatherKit

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    private let locationService = LocationService.shared

    var body: some View {
        VStack(spacing: 8) {
            if let weather = viewModel.weather, viewModel.error == nil {
                let temperature = String(format: "%.1f", weather.temperature)
                let humidity = String(format: "%.1f", weather.humidity * 100)
                let windSpeed = String(format: "%.1f", weather.windSpeed)
                
                Text("기온: \(temperature) °C")
                Text("습도: \(humidity) %")
                Text("풍속: \(windSpeed) m/s")
                Image(systemName: weather.description)
            }
            
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
            
            Spacer()
                .frame(height: 50)
            
            HStack {
                Text("위도: ")
                TextField("", text: $latitude)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("경도: ")
                TextField("", text: $longitude)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button("커스텀 위치 사용") {
                guard let latitude = Double(latitude),
                      let longitude = Double(longitude) else { return }
                
                let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
                locationService.send(location: location)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 12).fill(.gray)
            )
            
            Spacer()
                .frame(height: 50)
            
            Button("현재 위치 사용") {
                locationService.locationManager.requestLocation()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 12).fill(.gray)
            )
        }
        .padding()
        .onAppear {
            locationService.locationManager.requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
