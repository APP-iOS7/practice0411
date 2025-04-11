//
//  AgainTodoApp.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import SwiftUI
import SwiftData

@main
struct AgainTodoApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Todo.self,
//            Weather.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            TodoView()
        }
//        .modelContainer(sharedModelContainer)
    }
}
