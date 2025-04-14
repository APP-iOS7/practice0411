
import Foundation
import Combine
import SwiftData



final class TodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager
    private var weatherManager = WeatherManager()
    private var locationManager = LocationManager()
    private var cancellables: Set<AnyCancellable> = []
    private var cancellableTimer: AnyCancellable?
    
    private var selectedTodoList: [Todo] = []
    
    
    @Published var showAddTodoView: Bool = false
    @Published var showSelectBox: Bool = false
    @Published var todos: [Todo] = []
    @Published var isUpdateUI: Bool = false
    
    
    init (context: ModelContext) {
        self.modelManager = TodoModelManager(context: context)
        // Combine
        $todos
            .dropFirst()
            .sink { [weak self] updatedTodos in
                self?.modelManager.updateAllTodo(updatedTodos)
            }
            .store(in: &cancellables)
        
        cancellableTimer = Timer
            .publish(every: 600, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .map {[weak self] _ -> [Todo] in
                print("start")
                self?.fetchTodos()
                return self?.todos ?? []
            }
            .receive(on: DispatchQueue.global())
            .sink { [weak self] todo in
                Task {
                    guard let self = self else { return }
                    await self.updateWeatherData(todos: todo)
                    
                    await MainActor.run {
                        self.fetchTodos()
                        print("done")
                    }
                }
            }
        
        $showSelectBox
            .sink { [weak self] _ in
                self?.clearSelectedTodoList()
            }
            .store(in: &cancellables)
        
        // init excute
        fetchTodos()
        Task {
            await self.updateWeatherData(todos: self.todos)
            await MainActor.run {fetchTodos()}
        }
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
    
    func updateWeatherData(todos: [Todo]) async {
        var resultTodo: [Todo] = []
        
        for todo in todos {
            guard let deadline = todo.deadline else { continue }
            
            let location = locationManager.makeCLLocation(
                latitude: todo.weather?.latitude ?? 0,
                longitude: todo.weather?.longitude ?? 0
            )
            
            if let result = await weatherManager.getDayWeather(day: deadline, for: location) {
                let weatherItem = Weathers.makeModel(data: result, location: location)
                todo.weather = weatherItem
                resultTodo.append(todo)
            }
        }
        
        modelManager.updateAllTodo(resultTodo)
    }
    
    func addTodoListToSelectedBox(_ index: Int) {
        if !isSelectedTodoList(index: index) {
            selectedTodoList.append(todos[index])
        }
        else {
            selectedTodoList.remove(at: selectedTodoList.firstIndex(of: todos[index])!)
        }
        isUpdateUI.toggle()
    }
    
    func clearSelectedTodoList() {
        selectedTodoList.removeAll()
    }
    
    func isSelectedTodoList(index: Int) -> Bool {
        return selectedTodoList.contains(where: { $0.id == todos[index].id })
    }
    
    func saveSelectedTodoList() {
        for todo in selectedTodoList {
            todo.isDone.toggle()
            updateTodo(todo)
        }
        clearSelectedTodoList()
        showSelectBox.toggle()
    }
    
    func deleteSelectedTodoList() {
        for todo in selectedTodoList {
            deleteTodo(todo)
        }
        clearSelectedTodoList()
        fetchTodos()
        showSelectBox.toggle()
    }
}
