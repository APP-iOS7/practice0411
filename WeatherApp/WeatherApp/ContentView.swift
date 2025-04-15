//
//  ContentView.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {

    enum Field {
        case latitude
        case longitude
    }

    @EnvironmentObject var colorSchemeManager: ColorSchemeManager

    @StateObject var viewModel: WeatherViewModel = WeatherViewModel()

    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack{
            List {
                Section("날씨") {
                    Text("현재 온도: \(String(format: "%.1f", viewModel.weather?.temperature ?? 0.0)) °C")
                    HStack {
                        Text("날씨 설명: \(viewModel.weather?.description ?? "")")
                        if viewModel.weather != nil {
                            Image(systemName: viewModel.weather?.symbolName ?? "circle.dotted")
                        }
                    }
                    Text("현재 습도: \(String(format: "%.1f", viewModel.weather?.humidity ?? 0.0)) %")
                    Text("현재 풍속: \(String(format: "%.1f", viewModel.weather?.windSpeed ?? 0.0)) m/s")
                }
                Section("위치 정보") {
                    HStack {
                        Button("현재 위치 날씨 확인", action: getCurrentWeather)
                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                    VStack(alignment: HorizontalAlignment.leading) {
                        VStack {
                            TextField("위도(-90 ~ 90)      Ex) 37.33473020", text: $viewModel.latitude)
                                .focused($focusedField, equals: .latitude)
                                .keyboardType(.decimalPad)

                            Divider()

                            TextField("경도(-180 ~ 180)   Ex) 122.00891890", text: $viewModel.longitude)
                                .focused($focusedField, equals: .longitude)
                                .keyboardType(.decimalPad)
                        }
                    }
                    Button("입력 위치 날씨 가져오기", action: getWeatherOnCustomLocation)
                        .disabled(!viewModel.customLocationEnabled)
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
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing,
                            content: {
                    Button("새로고침", action: viewModel.resetWeather)
                })
                ToolbarItem(placement: .topBarLeading,
                            content: {
                    Button(colorSchemeManager.colorScheme == .light ? "다크 모드" : "라이트 모드", action: colorSchemeManager.toggle)
                })
            })
        }
    }

    func getCurrentWeather() {
        Task {
            await viewModel.fetchWeather()
        }
    }

    func getWeatherOnCustomLocation() {
        Task {
            await viewModel.fetchCustomLocationWeather()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ColorSchemeManager())
}
