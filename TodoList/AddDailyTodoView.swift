//
//  AddDailyTodoView.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/13/25.
//

import SwiftUI
import SwiftData

struct AddDailyTodoView: View {
    @ObservedObject var viewModel: DailyTodoListViewModel
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
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
            TextField("Add Daily Todo", text: $title)
        }
        
        Spacer()
        Button(action: {
            addDailyTodoItem()
        }) {
            Text("Add")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(title.isEmpty ? Color.gray : Color.teal)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .disabled(title.isEmpty)
        .navigationTitle("Add Daily Todo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private func addDailyTodoItem() {
        let categoryToAdd = selectedCategory == newCategoryOption ? (newCategory.isEmpty ? nil : newCategory) : selectedCategory
        viewModel.addDailyTodo(title: title, category: categoryToAdd)
        dismiss()
    }
}
