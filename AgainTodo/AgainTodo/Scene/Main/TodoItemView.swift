import SwiftUI

struct TodoItemView: View {
    @ObservedObject private var viewModel = TodoItemViewModel()
    
    var todoItem: Todo

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            let leftWidth = width * (1 - 0.2 - viewModel.gridRatio)
            let midWidth = width * 0.2
            let rightWidth = width * viewModel.gridRatio

            Grid(horizontalSpacing: 0) {
                GridRow {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(todoItem.title)
                                .font(.system(size: titleFontSize, weight: .bold))
                                .kerning(textKerning)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text(todoItem.detail)
                                .font(.system(size: subtitleFontSize))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    .frame(width: leftWidth)

                    VStack(alignment: .leading) {
                        Text("목표 일")
                            .font(.system(size: subtitleFontSize))
                            .foregroundStyle(.secondary)
                        Text("당일 날씨")
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: midWidth)

                    VStack(alignment: .leading) {
                        Text(todoItem.deadline?.description ?? "")
                            .font(.system(size: subtitleFontSize))
                            .foregroundStyle(.secondary)
                        Text(todoItem.weather?.weather ?? "")
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: rightWidth)
                    .onAppear {
                        let lineCount = numberTextLine(
                            todoItem.deadline?.description ?? "",
                            font: UIFont.systemFont(ofSize: subtitleFontSize),
                            maxWidth: rightWidth
                        )
                        if lineCount >= 2 {
                            viewModel.gridRatio = min(viewModel.gridRatio + 0.03, 0.5)
                        }
                    }
                }
                .frame(height: 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 50)
    }
}

#Preview {
    TodoItemView(todoItem: Todo.empty())
}
