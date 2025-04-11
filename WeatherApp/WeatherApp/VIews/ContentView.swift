//
//  ContentView.swift
//  WeatherApp
//
//  Created by NO SEONGGYEONG on 4/11/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView("날씨 정보를 가져오는 중...")
                .progressViewStyle(CircularProgressViewStyle())
        } else {
            
            VStack {
                Spacer()
                HStack {
                    Label("",systemImage: "sun.max.fill")
                        .font(.largeTitle)
                    Text("\(viewModel.weather.temperature, specifier: "%.1f") °C")
                        .font(.largeTitle)
                        .padding(.trailing, 10)
                    Text(viewModel.weather.description)
                        .font(.largeTitle)
                }
                Spacer()
                
                Text("습도: \(viewModel.weather.humdity, specifier: "%.1f") %")
                    .font(.title)
                Spacer()
                
                Text("풍속: \(viewModel.weather.windSpeed, specifier: "%.1f") m/s")
                    .font(.title)
                Spacer()
                
                Text("추천 옷차림: \(viewModel.weather.clothes)")
                    .font(.title)
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.checkWeather()
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                        .font(.largeTitle)
                })
                
                
                Spacer()
                
            }
            .task {
                await viewModel.checkWeather()
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
