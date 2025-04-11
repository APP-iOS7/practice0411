

import Foundation
import SwiftData

final class TodoModelManager {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    static let shared = TodoModelManager()
    
    private init() {
        modelContainer = try! ModelContainer.init(
            for: Schema([Todo.self, Weather.self]),
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        modelContext = ModelContext(modelContainer)
    }
    
    //MARK: Todo - CRUD
    func fetchTodos() -> [Todo] {
        do {
            return try modelContext.fetch(FetchDescriptor<Todo>())
        }
        catch {
            print("FETCH ERROR: \(error)")
            return []
        }
    }
    
    func insertTodo(_ todo: Todo) {
        do {
            modelContext.insert(todo)
            try modelContext.save()
        }
        catch {
            print("SAVE ERROR: \(error)")
        }
    }
    
    func updateTodo(_ todo: Todo) {
        do {
            try modelContext.save()
        }
        catch {
            print("SAVE ERROR: \(error)")
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        do {
            modelContext.delete(todo)
            try modelContext.save()
        }
        catch {
            print("DELETE ERROR: \(error)")
        }
    }
    
}
