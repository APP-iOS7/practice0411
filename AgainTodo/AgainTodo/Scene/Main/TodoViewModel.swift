
import Foundation
import Combine



final class TodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager = .shared
    
    @Published var showAddTodoView: Bool = false
    
    func fetchTodos() -> [Todo] {
        return modelManager.fetchTodos()
    }
}
