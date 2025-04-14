//
//  DailyTodoListViewModel.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/13/25.
//

import SwiftUI
import SwiftData
import Combine

class DailyTodoListViewModel: ObservableObject {
    private let controller: TodoController
    
    @Published var dailyTodoItems: [TodoItem] = []
    @Published var searchText = ""
    @Published var selectedCategory: String?
    
    private var midnightTimer: Timer?
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
        self.controller = TodoController(modelContext: modelContext)
        self.modelContext = modelContext
        fetchDailyTodoItems()
        setupBindings()
        startMidnightResetTimer()
    }
    
    var filteredItems: [TodoItem] {
        dailyTodoItems.filter { item in
            (searchText.isEmpty || item.title.lowercased().contains(searchText.lowercased())) &&
            (selectedCategory == nil || item.category == selectedCategory)
        }
    }
    
    private func setupBindings() {
        $searchText
            .combineLatest($selectedCategory)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    
    func uniqueCategories() -> [String] {
        Array(Set(dailyTodoItems.compactMap { $0.category })).sorted()
    }
    
    func addDailyTodo(title: String, category: String?) {
        let newItem = TodoItem(title: title, category: category)
        controller.addTodo(withItem: newItem)
        fetchDailyTodoItems()
    }
    
    func toggleCompleted(for item: TodoItem) {
        controller.changeComplete(for: item, isCompleted: !item.isCompleted)
        fetchDailyTodoItems()
    }
    
    func removeDailyTodo(at offsets: IndexSet) {
        let itemsToRemove = offsets.map { dailyTodoItems[$0] }
        controller.removeTodo(withItems: itemsToRemove)
        fetchDailyTodoItems()
    }
    
    func fetchDailyTodoItems() {
        var descriptor = FetchDescriptor<TodoItem>(
            sortBy: [SortDescriptor(\.title)]
        )
        // 날짜 입력이 되지 않은 할 일을 데일리 투두 리스트에 출력
        descriptor.predicate = #Predicate { $0.createdAt == nil }
        do {
            dailyTodoItems = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    // MARK: 자정에 할 일 초기화
    func resetDailyTodos() {
        dailyTodoItems.forEach { item in
            controller.changeComplete(for: item, isCompleted: false)
        }
        fetchDailyTodoItems()
    }
    
    private func startMidnightResetTimer() {
        // 다음 자정 시간 계산
        func getNextMidnightPublisher() -> AnyPublisher<Date, Never> {
            let calendar = Calendar.current
            let now = Date()
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.day! += 1
            guard let nextMidnight = calendar.date(from: components) else {
                return Just(Date()).eraseToAnyPublisher()
            }
            // Future를 사용해 자정에 도달하면 Date를 방출
            let timeInterval = nextMidnight.timeIntervalSince(now)
            return Future<Date, Never> { promise in
                DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                    promise(.success(nextMidnight))
                }
            }.eraseToAnyPublisher()
        }
        
        // sink로 resetDailyTodos를 호출하고 다음 자정 타이머를 스케줄 해줌
        getNextMidnightPublisher()
            .sink { [weak self] _ in
                self?.resetDailyTodos()
                print("리셋 완료: \(Date())")
                // 재귀적으로 다음 자정 타이머 시작
                self?.startMidnightResetTimer()
            }
            .store(in: &cancellables) // 구독을 저장해서 뷰 모델이 해제될 때 자동으로 정리
    }
    
    deinit {
        print("DailyTodoListViewModel deallocated")
    }
}
