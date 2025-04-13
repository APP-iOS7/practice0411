//
//  ContentView.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            NavigationStack {
                TodoListView(modelContext: modelContext)
            }
            .tabItem {
                Label("Todos", systemImage: "list.bullet")
            }
            
            NavigationStack {
                DailyTodoListView(modelContext: modelContext)
            }
            .tabItem {
                Label("Daily Todos", systemImage: "arrow.clockwise")
            }
        }
        .tint(.black)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: TodoItem.self, DailyTodoItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    return ContentView()
        .modelContainer(container)
}
