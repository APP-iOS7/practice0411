//
//  ContentView.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#E7EEFF")
                .opacity(1.0)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if let weather = viewModel.weather {
                    WeatherInfoView(weather: weather)
                } else {
                    // TODO: 날씨 없을때 뷰
                    Text("Empty")
                }

                RefreshButton(isLoading: viewModel.isLoading) {
                    viewModel.refreshWeather()
                }
            }
            .padding(20)
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onAppear {
            viewModel.requestLocationPermission()
            viewModel.refreshWeather()
        }
    }
}

struct WeatherInfoView: View {
    let weather: WeatherData

    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
            
            VStack(alignment: .center, spacing: 16) {
                Image(systemName: Constants.WeatherIcons.iconFame(for: weather.description))
                    .font(.system(size: 60))
                    .foregroundStyle(Color(hex: "#FFFFFF"))
                
                // 온도 정보
                Text("\(Int(weather.temperature))°C")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundStyle(Color(hex: "#FFFFFF"))
                
                // 날씨 설명
                Text(weather.description)
                    .font(.title)
                    .foregroundStyle(Color(hex: "#FFFFFF"))
                
                Divider()
                    .background(Color(hex: "#FFFFFF"))
                
                HStack(spacing: 30) {
                    // 습도 정보
                    VStack {
                        Image(systemName: "humidity")
                            .font(.title)
                        Text("습도")
                            .font(.caption)
                        Text("\(Int(weather.humidity * 100))%")
                            .font(.title3)
                    }
                    
                    // 풍속 정보
                    VStack {
                        Image(systemName: "wind")
                            .font(.title)
                        Text("풍속")
                            .font(.caption)
                        Text("\(Int(weather.windSpeed))m/s")
                            .font(.title3)
                    }
                }
                .foregroundStyle(Color(hex: "#FFFFFF"))
                .padding(.top, 10)
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "#CCE0FF"),
                    Color(hex: "#0120E0"),
                ],
                startPoint: .top,
                endPoint: .bottomTrailing))
        .cornerRadius(12)
    }
    
}

/// 새로고침 버튼 컴포넌트
struct RefreshButton: View {
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("새로고침", systemImage: "arrow.clockwise")
                .font(.headline)
                .foregroundColor(Color(hex: "#FFFFFF"))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#498DF2"))
                .cornerRadius(10)
        }
        .disabled(isLoading)
    }
}

/// 로딩 오버레이 뷰 컴포넌트
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack() {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("날씨 정보를 가져오는 중...")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
            .padding(20)
//            .background(Color.gray.opacity(0.8))
            .cornerRadius(10)
        }
    }
}


#Preview {
    WeatherView()
}
