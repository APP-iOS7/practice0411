//
//  ContentView.swift
//  WeatherApp
//
//  Created by 박세라 on 4/11/25.
//

import SwiftUI

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let weather = viewModel.weather {
                    Form {
                        Section {
                            HStack {
                                TextField("위치 입력", text: $viewModel.location)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                Button("검색") {
                                    Task {
                                        // 검색 버튼이 눌리면 날씨 정보 검색
                                        await viewModel.fetchWeatherByLocation()
                                    }
                                }
                                .frame(width: 52, height: 40)
                                .padding(.vertical, 0) // 세로 방향 패딩을 0으로 설정하여 버튼 높이 조정
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            HStack {
                                Text("🌡️")
                                Text("온도")
                                Spacer()
                                Text("\(weather.temperature, specifier: "%.1f")℃")
                            }
                            HStack {
                                Image(systemName: weather.symbolName)
                                Text("설명")
                                Spacer()
                                Text(weather.description)
                            }
                            HStack {
                                Text("🥵")
                                Text("습도")
                                Spacer()
                                Text("\(Int(weather.humidity))%")
                            }
                            HStack {
                                Text("💨")
                                Text("풍속")
                                Spacer()
                                Text("\(weather.windSpeed, specifier: "%.1f") m/s")
                            }
                        }
                    }
                    // 나머지 날씨 정보 표시
                } else if let error = viewModel.errorMessage {
                    Text("⚠️ \(error)")
                        .foregroundColor(.red)
                } else {
                    Text("날씨 정보를 불러오세요.")
                }
                
                Button("현재 위치로 날씨 보기") {
                    locationManager.requestLocation()
                }
                .padding()
                
                // 권한이 거부되었을 때의 메시지
                if locationManager.authorizationStatus == .denied {
                    Text("위치 권한이 꺼져 있어요. 설정에서 켜주세요.")
                        .foregroundColor(.red)
                }
            }
            .onReceive(locationManager.$currentLocation.compactMap { $0 }) { location in
                // 위치가 업데이트 되면 날씨 데이터 요청
                if viewModel.weather == nil { // 날씨 데이터가 없는 경우에만 요청
                    Task {
                        await viewModel.fetchWeather(currentLocation: location)
                    }
                }
            }
            .navigationTitle("Weather")
        }
        .onAppear {
            // 위치 권한 요청
            locationManager.requestAuthorization()
        }
    }
}
