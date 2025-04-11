//
//  ContentView.swift
//  WeatherApp
//
//  Created by 박세라 on 4/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("위치 입력 (예: 서울)", text: $viewModel.location)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    
                    Button("날씨 가져오기") {
                        Task {
                            await viewModel.fetchWeather()
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView("날씨 정보를 불러오는 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                }
                
                if let weather = viewModel.weather {
                    Section {
                        HStack {
                            Text("🌡️")
                            Text("온도")
                            Spacer()
                            Text("\(weather.temperature, specifier: "%.1f")℃")
                        }
                        HStack {
                            Text("ℹ️")
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
                
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Weather")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.fetchWeather()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
