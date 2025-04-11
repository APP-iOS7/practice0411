//
//  AddTodoView.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/11/25.
//

import SwiftUI
import SwiftData

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @Environment(\.dismiss) var dismiss
    @State var title = ""
    @State var selectedDate: Date = Date()
    @State private var selectedCategory: String? = nil
    @State private var newCategory = ""
    private let newCategoryOption = "New Category"
    
    var body: some View {
            Form {
                Picker("Category", selection: $selectedCategory) {
                    Text("None").tag(String?.none)
                    ForEach(viewModel.uniqueCategories(), id: \.self) { category in
                        Text(category).tag(String?.some(category))
                    }
                    Text(newCategoryOption).tag(String?.some(newCategoryOption))
                }
                .pickerStyle(.menu)
                
                if selectedCategory == newCategoryOption {
                    TextField("New Category", text: $newCategory)
                }
                TextField("Add Todo", text: $title)
                DatePicker("Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.automatic)
            }
            
            Spacer()
            Button(action: {
                addTodoItem()
            }) {
                Text("Add")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
                        .padding(.bottom, 10)
            .disabled(title.isEmpty)
        .navigationTitle("Add Todo")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private func addTodoItem() {
            let categoryToAdd = selectedCategory == newCategoryOption ? (newCategory.isEmpty ? nil : newCategory) : selectedCategory
            viewModel.addTodo(title: title, createdAt: selectedDate, category: categoryToAdd)
            dismiss()
        }
}


#Preview {
    // ModelContainer 생성
    let container = try! ModelContainer(
        for: TodoItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    // TodoListViewModel 초기화
    let viewModel = TodoListViewModel(modelContext: container.mainContext)
    // NavigationStack으로 래핑
    return NavigationStack {
        AddTodoView(viewModel: viewModel)
    }
    .modelContainer(container)
}
