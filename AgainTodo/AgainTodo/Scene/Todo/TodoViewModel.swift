
import Foundation
import Combine



final class TodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager = .shared
    private var cancellables: Set<AnyCancellable> = []
    
    
    @Published var showAddTodoView: Bool = false
    @Published var showCheckBox: Bool = false
    @Published var todos: [Todo] = []
    
    init () {
        $todos
            .dropFirst()
            .sink { [weak self] updatedTodos in
                self?.modelManager.updateAllTodo(updatedTodos)
            }
            .store(in: &cancellables)
        fetchTodos()
    }
    
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
