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
        TodoListView(modelContext: modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
