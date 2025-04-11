
import Foundation
import Combine



final class TodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager = .shared
    private var weatherManager = WeatherManager()
    private var locationManager = LocationManager()
    private var cancellables: Set<AnyCancellable> = []
    private var cancellableTimer: AnyCancellable?
    
    
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
        
        cancellableTimer = Timer
            .publish(every: 600, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .map {[weak self] _ -> [Todo] in
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
                        print(todo.first?.weather?.maxTemp ?? 0)
                    }
                }
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
}
