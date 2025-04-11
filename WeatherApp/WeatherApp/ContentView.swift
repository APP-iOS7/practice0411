//
//  ContentView.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager

    @StateObject var viewModel: WeatherViewModel = WeatherViewModel()
    
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case latitude
        case longitude
    }
    
    var body: some View {
        NavigationStack{
            List {
                Section("날씨") {
                    Text("현재 온도: \(String(format: "%.1f", viewModel.weather?.temperature ?? 0.0)) °C")
                    HStack {
                        Text("날씨 설명: \(viewModel.weather?.description ?? "")")
                        Image(systemName: viewModel.weather?.symbolName ?? "")
                    }
                    Text("현재 습도: \(String(format: "%.1f", viewModel.weather?.humidity ?? 0.0)) %")
                    Text("현재 풍속: \(String(format: "%.1f", viewModel.weather?.windSpeed ?? 0.0)) m/s")
                }
                Section("위치 정보") {
                    HStack {
                        Button("현재 위치 날씨 확인", action: {
                            Task {
                                await viewModel.fetchWeather()
                                latitude = viewModel.location.coordinate.latitude.description
                                longitude = viewModel.location.coordinate.longitude.description
                            }
                        })
                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                    VStack(alignment: HorizontalAlignment.leading) {
                        VStack {
                            TextField("위도(-90 ~ 90)      Ex) 37.33473020", text: $latitude)
                                .keyboardType(.decimalPad)

                            Divider()
                            TextField("경도(-180 ~ 180)   Ex) 122.00891890", text: $longitude)
                                .keyboardType(.decimalPad)

                        }
                    }
                    Button("위치 직접 입력", action: {
                        Task {
                            viewModel.error = nil
                            await viewModel.fetchCustomLocationWeather(latitude, longitude)
                        }
                    })
                }
                Section {
                    Text(viewModel.error?.localizedDescription ?? "")
                        .listRowBackground(Color.clear)
                }
                .foregroundStyle(.red)
            }
            
            .navigationTitle("Weather App")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("완료") {
                        focusedField = nil
                        hideKeyboard()
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing,
                            content: {
                    Button("새로고침", action: {
                        viewModel.error = nil
                        viewModel.resetWeather()
                        latitude = ""
                        longitude = ""
                    })
                })
                ToolbarItem(placement: .topBarLeading,
                            content: {
                    Button(colorSchemeManager.colorScheme == .light ? "다크 모드" : "라이트 모드", action: {
                        colorSchemeManager.toggle()
                    })
                })
            })
        }
        
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(ColorSchemeManager())
}
