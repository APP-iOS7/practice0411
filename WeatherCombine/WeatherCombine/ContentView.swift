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
        VStack {
            if let weather = viewModel.weather {
                Text("기온: \(weather.temperature)")
                Text("습도: \(weather.humidity)")
                Text("풍속: \(weather.windSpeed)")
                Text("\(weather.description)")
            } else {
                Text("날씨 정보 로딩중...")
            }
            
            Spacer()
                .frame(height: 30)
            
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
