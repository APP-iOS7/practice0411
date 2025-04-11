
import Foundation
import Combine



final class TodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager = .shared
    
    
    @Published var showAddTodoView: Bool = false
    @Published var showCheckBox: Bool = false
    @Published var todos: [Todo] = []
    
    func fetchTodos() {
        todos = modelManager.fetchTodos()
    }
    
    func updateTodo(_ todo: Todo) {
        modelManager.updateTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        modelManager.deleteTodo(todo)
    }
}
