//
//  ContentView.swift
//  WeatherApp
//
//  Created by 박세라 on 4/11/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    //@StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        /*
                        TextField($viewModel.location, text: "dd")
                         */
                    }
                    HStack {
                        Text("🌡️")
                        Text("온도")
                        Spacer()
                        Text("7")
                    }
                    HStack {
                        Text("ℹ")
                        Text("정보")
                        Spacer()
                        Text("")
                    }
                    HStack {
                        Text("🥵")
                        Text("습도")
                        Spacer()
                        Text("17%")
                    }
                    HStack {
                        Text("💨")
                        Text("풍속")
                        Spacer()
                        Text("7ms")
                    }
                }
            }.navigationTitle("Weather")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("버튼 눌림!")
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
