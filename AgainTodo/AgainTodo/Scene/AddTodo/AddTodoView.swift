//
//  AddTodoView.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddTodoViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("할 일")
                    TextField("할 일을 입력해주세요.",text: $viewModel.title)
                }
                
                HStack(alignment: .top) {
                    Text("상세")
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.detail)
                        if viewModel.detail.isEmpty {
                            Text("자세한 내용을 입력해주세요.")
                                .foregroundStyle(.gray.opacity(0.5))
                        }
                    }
                    .frame(height: 300)
                }
                .padding(.top)
                Button(action: {viewModel.showDatePicker.toggle()},label: {Text(viewModel.showDatePicker == true ?  "취소하기" : "마감일 설정하기").foregroundStyle(.black)})
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                if viewModel.showDatePicker {
                    DatePicker("마감일 선택", selection: $viewModel.date, displayedComponents: [.date])
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            viewModel.saveTodo()
                            dismiss()
                        },
                        label: {Text("저장하기").foregroundStyle(viewModel.isFormValid ? .black : .gray.opacity(0.5))}
                    )
                    .disabled(!viewModel.isFormValid)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {dismiss()}, label: {Text("취소하기").foregroundStyle(.black)})
                }
            }
        }
    }
}

#Preview {
    AddTodoView()
}
