//
//  ContentView.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var viewModel: WeatherViewModel = WeatherViewModel()
    
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    var body: some View {
        NavigationStack{
            List {
                Section("날씨") {
                    Text("현재 온도: \(String(format: "%.1f", viewModel.weather?.temperature ?? 0.0)) °C")
                    Text("날씨 설명: \(viewModel.weather?.description ?? "")")
                    Text("현재 습도: \(String(format: "%.1f", viewModel.weather?.humidity ?? 0.0)) %")
                    Text("현재 풍속: \(String(format: "%.1f", viewModel.weather?.windSpeed ?? 0.0)) m/s")
                }
                Section("위치 정보") {
                    Button("현재 위치 사용", action: {
                        Task {
                            await viewModel.fetchWeather()
                        }
                    })
                    VStack(alignment: HorizontalAlignment.leading) {
                        Spacer()
                        Text("위치 직접 입력")
                        Spacer()
                        VStack {
                            TextField("위도                    Example) 37.33473020", text: $latitude)
                            TextField("경도                    Example) 122.00891890", text: $longitude)
                        }
                        Spacer()
                        Button("확인", action: {
                            Task {
                                viewModel.error = nil
                                await viewModel.fetchCustomLocationWeather(latitude, longitude)
                            }
                        })
                        Spacer()
                    }
                }
                Section {
                    Text(viewModel.error?.localizedDescription ?? "")
                        .listRowBackground(Color.clear)
                }
                .foregroundStyle(.red)
                //                ProgressView()
            }
            
            .navigationTitle("Weather App")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing,
                            content: {
                    Button("새로고침", action: {
                        viewModel.resetWeather()
                    })
                })
                ToolbarItem(placement: .topBarLeading,
                            content: {
                    Button("다크모드", action: {
//                        viewModel.resetWeather()
                    })
                })
            })
        }
        
    }
}

#Preview {
    ContentView()
}
