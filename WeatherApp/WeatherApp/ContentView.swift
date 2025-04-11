//
//  ContentView.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
   // @Query private var items: [Item]
    var tag = 1

    var body: some View {
        TabView {
            Tab("RealTime", systemImage: "sun.max") {
                RealtimeWeatherView()
            }
            
            Tab("WeekWeather", systemImage: "calendar.badge.plus") {
                WeekWeatherView()
            }
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
