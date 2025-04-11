
import Foundation
import Combine



final class TodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager = .shared
    
    
    @Published var showAddTodoView: Bool = false
    @Published var todos: [Todo] = []
    
    func fetchTodos() {
        todos = modelManager.fetchTodos()
    }
}
