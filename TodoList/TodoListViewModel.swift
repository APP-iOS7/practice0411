//
//  TodoListViewModel.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/11/25.
//
import SwiftUI
import Combine
import SwiftData

class TodoListViewModel: ObservableObject {
    @Published var todoItems: [TodoItem] = []
    @Published var filteredItems: [TodoItem] = []
    @Published var newTodo: String = ""
    @Published var isCompleted: Bool = false
    @Published var showCompleted: Bool = true
    @Published var selectedCategory: String? = nil
    
    // Combine 구독 저장
    private var cancellables: Set<AnyCancellable> = []
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupDataObservation()
        setupFiltering()
    }
    
    // MARK: 데이터 변경 감지 설정
    private func setupDataObservation() {
        // ModelContext의 저장 이벤트를 NotificationCenter로 감지
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: modelContext) // 이벤트를 Combine의 Publisher로 변환해준다.
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main) // 100ms 안에 연속으로 발생하는 저장 이벤트를 하나로 묶어줌
            .sink { [weak self] _ in // 약한 참조로 메모리 누수를 방지
                self?.fetchTodoItems()
            } // sink로 이벤트를 받아 fetchTodoItems()를 호출해서 todoItems를 최신 상태로 갱신
            .store(in: &cancellables)
        
        // 초기 데이터 로드
        fetchTodoItems()
    }
    
    // MARK: 리스트 필터링 설정
    private func setupFiltering() {
        Publishers.CombineLatest3($todoItems, $showCompleted, $selectedCategory) // publishers로 값이 바뀔 때마다 새로운 값을 방출해줌. CombineLatest3로 3개의 객체 값일 바뀔 때마다 최신 값을 결합해서 쌍으로 방출해줌.
            .map { items, showCompleted, selectedCategory in // CombineLatest가 방출한 값을 받아서 변환해줌
                var filtered = items
                if !showCompleted {
                    filtered = filtered.filter { !$0.isCompleted }
                }
                if let category = selectedCategory {
                    filtered = filtered.filter { $0.category == category }
                }
                return filtered
            }
            .assign(to: \.filteredItems, on: self) // .map으로 나온 배열을 filteredItems에 할당
            .store(in: &cancellables) // TodoListViewModel이 해제 될 떄 구독도 자동으로 정리돼서 메모리 누수 방지
    }
    
    
    // MARK: 할 일 가져오기
    func fetchTodoItems() {
        do {
            let descriptor = FetchDescriptor<TodoItem>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
            todoItems = try modelContext.fetch(descriptor)
        } catch {
            print("fetch failed: \(error)")
        }
    }
    
    // MARK: 새 할일 추가
    func addTodo(title: String, createdAt: Date, category: String?) {
        guard !title.isEmpty else { return }
        let newItem = TodoItem(title: title, createdAt: createdAt, isCompleted: isCompleted, category: category)
        modelContext.insert(newItem)
        saveContext()
        fetchTodoItems()
    }
    
    //MARK: 할 일 제거
    func removeTodo(at indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(todoItems[index])
            saveContext()
            fetchTodoItems()
        }
    }
    
    // MARK: 완료 된 것 지우기
    func toggleCompleted(for item: TodoItem) {
        item.isCompleted.toggle()
        saveContext()
        fetchTodoItems()
    }
    
    // MARK: 저장 공통 로직
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("save failed: \(error)")
        }
    }
    
    // MARK: 카테고리 생성
    func uniqueCategories() -> [String] {
        Array(Set(todoItems.compactMap { $0.category })).sorted()
    }
}
