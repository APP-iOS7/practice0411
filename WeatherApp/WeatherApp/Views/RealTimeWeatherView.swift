//
//  RealTimeWeatherView.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import SwiftUI

struct RealtimeWeatherView: View {
    @StateObject private var viewModel = RealtimeWeatherViewModel()
    var body: some View {
        VStack {
            HStack {
                Text("현 위치 -> \(viewModel.location)")
                Spacer()
                Button("위치정보 가져오기") {
                    
                }
            }
           
            ScrollView {
                Text("RT")
            }.navigationTitle("Real Time Weather")
        }
        
    }
}

//#Preview {
//    RealtimeWeatherView()
//}
