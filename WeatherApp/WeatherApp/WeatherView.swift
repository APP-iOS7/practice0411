//
//  ContentView.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import SwiftUI
import CoreLocation

// TODO: ViewModel 생성 후 View 연결
struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#E7EEFF")
                .opacity(1.0)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                WeatherInfoView(weather: weather ?? WeatherData(temperature: 0, description: "맑음", humidity: 0, windSpeed: 0))
                
                RefreshButton(isLoading: isLoading) {
                    Task {
                        
                    }
                }
                
                
            }
            .padding(20)
            
            LoadingView()
        }
    }
}

struct WeatherInfoView: View {
    let weather: WeatherData
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
            
            VStack(alignment: .center, spacing: 16) {
                // 온도 정보
                Text("\(Int(weather.temperature))°C")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundStyle(Color(hex: "#FFFFFF"))
                
                // 날씨 설명
                Text(weather.description)
                    .font(.title)
                    .foregroundStyle(Color(hex: "#FFFFFF"))
                
                Divider()
                
                // 추가 날씨 정보 (습도, 풍속)
                HStack(spacing: 30) {
                    // 습도 정보
                    WeatherDataItem(
                        iconName: "humidity",
                        title: "습도",
                        value: "\(Int(weather.humidity * 100))%"
                    )
                    
                    // 풍속 정보
                    WeatherDataItem(
                        iconName: "wind",
                        title: "풍속",
                        value: "\(Int(weather.windSpeed))m/s"
                    )
                }
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

/// 날씨 데이터 항목 컴포넌트 (아이콘, 제목, 값)
struct WeatherDataItem: View {
    let iconName: String
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.title)
            Text(title)
                .font(.caption)
            Text(value)
                .font(.title3)
        }
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
