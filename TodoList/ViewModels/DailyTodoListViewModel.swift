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
    @Published var dailyTodoItems: [TodoItem] = []
    @Published var searchText = ""
    @Published var selectedCategory: String?
    
    private var midnightTimer: Timer?
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
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
    
    func uniqueCategories() -> [String] {
        Array(Set(dailyTodoItems.compactMap { $0.category })).sorted()
    }
    
    func addDailyTodo(title: String, category: String?) {
        let newItem = TodoItem(title: title, category: category)
        modelContext.insert(newItem)
        try? modelContext.save()
        fetchDailyTodoItems()
        
    }
    
    func toggleCompleted(for item: TodoItem) {
        item.isCompleted.toggle()
        try? modelContext.save()
        fetchDailyTodoItems()
    }
    
    func removeDailyTodo(at offsets: IndexSet) {
        offsets.forEach { index in
            modelContext.delete(filteredItems[index])
        }
        try? modelContext.save()
        fetchDailyTodoItems()
    }
    
    func fetchDailyTodoItems() {
        let descriptor = FetchDescriptor<TodoItem>(sortBy: [SortDescriptor(\.title)])
        do {
            dailyTodoItems = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
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
    
    func resetDailyTodos() {
        dailyTodoItems.forEach { $0.isCompleted = false }
        try? modelContext.save()
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
