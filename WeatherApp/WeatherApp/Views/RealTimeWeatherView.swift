//
//  RealTimeWeatherView.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import SwiftUI
import CoreLocation

struct RealtimeWeatherView: View {
    @StateObject private var viewModel = RealtimeWeatherViewModel()
    @State private var longitude: String = ""
    @State private var latitude: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("현 위치")
                        Text("경도 : \(viewModel.location.coordinate.latitude)")
                        Text("위도 : \(viewModel.location.coordinate.longitude)")
                    }
                    Spacer()
                    Button("위치정보 가져오기") {
                        viewModel.getLocationPermission()
                        viewModel.getLocation()
                    }.buttonStyle(.borderedProminent)
                } .padding()
                HStack {
                    Text("경도 입력")
                    TextField("127.23", text: $latitude)
                        .keyboardType(.numberPad)
                    Text("위도 입력")
                    TextField("35.5", text: $longitude)
                        .keyboardType(.numberPad)
                    Button("ENTER"){
                        updateViewModelLocation()
                    }
                }
                .padding()
                .border(.black)
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            Image(systemName: viewModel.weather?.icon ?? "circle.dotted")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .padding()
                            Text(" \(viewModel.weather?.weatherDescription ?? "몰랑")")
                                .font(.title)
                            Text("기온 \(String(format: "%.1f", viewModel.weather?.temperature ?? 0.0)) 도")
                                .font(.headline)
                            Text("습도 \(String(format: "%.1f", viewModel.weather?.humidity ?? 0.0)) %")
                                .font(.callout)
                            Text("풍속 \(String(format: "%.1f", viewModel.weather?.windSpeed ?? 0.0)) mps")
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Real Time Weather")
        }
    }

    func updateViewModelLocation() {
        guard let longitudeDouble: Double = Double(longitude),
              let latitudeDouble: Double = Double(latitude)
        else {
            return
        }

        let newLocation: CLLocation = CLLocation.init(latitude: latitudeDouble, longitude: longitudeDouble)
        viewModel.location = newLocation
    }

    func checkDoubleOnSummit(text: String) -> Bool {
        return Double(text) != nil
    }
}

#Preview {
    TabView {
        Tab("RealTime", systemImage: "sun.max") {
            RealtimeWeatherView()
        }
    }
}
