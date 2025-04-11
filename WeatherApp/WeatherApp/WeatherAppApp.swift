//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import SwiftUI
import SwiftData

//
/*
 이 앱의 목적
 - 현재 날씨 확인
 - 미래 날씨 확인
 - 관심지역 등록
 - 맵킷으로 이동하면 실시간으로 날씨 요약본 띄우기
 - 캐싱
 */

@main
struct WeatherAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SDWeatherData.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
