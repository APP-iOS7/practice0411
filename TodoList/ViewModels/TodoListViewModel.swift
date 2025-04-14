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
    private let controller: TodoController

    @Published var todoItems: [TodoItem] = []
    @Published var filteredItems: [TodoItem] = []

    @Published var showCompleted: Bool = true
    @Published var selectedCategory: String? = nil
    @Published var searchText: String = ""

    // Combine 구독 저장
    private var cancellables: Set<AnyCancellable> = []
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        // modelContext는 SwiftData에서 제공하는 데이터베이스와의 연결을 관리하는 객체
        self.modelContext = modelContext
        // TodoController는 모델과 뷰모델 사이의 상호작용을 관리하는 객체
        self.controller = TodoController(modelContext: modelContext)
        // UI 이벤트 리스너 설정
        setupFiltering()
        // 데이터 가져오기
        fetchTodoItems()
    }

    // MARK: 리스트 필터링 설정
    private func setupFiltering() {
        Publishers.CombineLatest4($todoItems, $showCompleted, $selectedCategory, $searchText) // publishers로 값이 바뀔 때마다 새로운 값을 방출해줌. CombineLatest3로 3개의 객체 값일 바뀔 때마다 최신 값을 결합해서 쌍으로 방출해줌.
            .map { items, showCompleted, selectedCategory, searchText in // CombineLatest가 방출한 값을 받아서 변환해줌
                var filtered = items
                if !showCompleted {
                    filtered = filtered.filter { !$0.isCompleted }
                }
                if let category = selectedCategory {
                    filtered = filtered.filter { $0.category == category }
                }
                if !searchText.isEmpty {
                    filtered = filtered.filter {
                        $0.title.localizedCaseInsensitiveContains(searchText) ||
                        ($0.category?.localizedCaseInsensitiveContains(searchText) ?? false)
                    }
                }
                return filtered
            }
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .assign(to: \.filteredItems, on: self) // .map으로 나온 배열을 filteredItems에 할당
            .store(in: &cancellables) // TodoListViewModel이 해제 될 떄 구독도 자동으로 정리돼서 메모리 누수 방지
    }


    // MARK: 할 일 가져오기
    func fetchTodoItems() {
        do {
            var descriptor = FetchDescriptor<TodoItem>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
            // createdAt이 nil이 아닌 것만 가져옴
            descriptor.predicate = #Predicate { $0.createdAt != nil }
            todoItems = try modelContext.fetch(descriptor)
        } catch {
            print("fetch failed: \(error)")
        }
    }

    // MARK: 새 할일 추가
    func addTodo(title: String, createdAt: Date, category: String?) {
        guard !title.isEmpty else { return }
        let newItem = TodoItem(title: title, createdAt: createdAt, isCompleted: false,
                               category: category)
        controller.addTodo(withItem: newItem)
        fetchTodoItems()
    }

    //MARK: 할 일 제거
    func removeTodo(at indexSet: IndexSet) {
        // FIXME: filterItems 와 todoItems 구분
        let removeItems = indexSet.map { todoItems[$0] }
        controller.removeTodo(withItems: removeItems)
        fetchTodoItems()
    }

    // MARK: 완료 된 것 지우기
    func toggleCompleted(for item: TodoItem) {
        controller.changeComplete(for: item, isCompleted: !item.isCompleted)
        fetchTodoItems()
    }

    // MARK: 카테고리 생성
    func uniqueCategories() -> [String] {
        Array(Set(todoItems.compactMap { $0.category })).sorted()
    }
}
