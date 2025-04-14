

import Foundation
import SwiftData

final class TodoModelManager {
    private let modelContext: ModelContext

    init(context: ModelContext) {
        modelContext = context
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
            guard let todos = try modelContext.fetch(FetchDescriptor<Todo>()).first(where: { $0.id == todo.id })
            else {
                return
            }
            
            todos.title = todo.title
            todos.detail = todo.detail
            todos.deadline = todo.deadline
            todos.weather = todo.weather
            todos.isDone = todo.isDone
            
            try modelContext.save()
        } catch {
            print("UPDATE ERROR: \(error)")
        }
    }
    
    func updateAllTodo(_ todos: [Todo]) {
        do {
            for todo in todos {
                modelContext.insert(todo)
            }
            try modelContext.save()
        } catch {
            print("UPDATE ALL ERROR: \(error)")
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
