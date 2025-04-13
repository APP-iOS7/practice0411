

import SwiftUI

struct TodoDetailView: View {
    @ObservedObject private var viewModel = TodoDetailViewModel()
    
    let todo: Todo
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("할 일")
                        .frame(width: detailItemWidth, alignment: .leading)
                        .fontWeight(detailSubtitleFontWeight)
                    Text(todo.title)
                }
                HStack {
                    Text("상세 내용")
                        .frame(width: detailItemWidth, alignment: .leading)
                        .fontWeight(detailSubtitleFontWeight)
                    Text(todo.detail)
                }
                HStack {
                    Text("마감일")
                        .frame(width: detailItemWidth, alignment: .leading)
                        .fontWeight(detailSubtitleFontWeight)
                    Text(viewModel.dateFormatter(todo.deadline))
                }
                HStack {
                    Text("완료 여부")
                        .frame(width: detailItemWidth, alignment: .leading)
                        .fontWeight(detailSubtitleFontWeight)
                    Text(todo.isDone ? "완료" : "미완료")
                }
            } header: {
                Text("할 일 상세 정보")
                    .foregroundStyle(.black)
                    .font(.system(size: sectionFontSize, weight: detailTitleFontWeight))
                    
            }
            
            if todo.weather != nil {
                Section {
                    HStack {
                        Image(systemName: todo.weather?.icon ?? "camera.metering.unknown")
                            .resizable()
                            .scaledToFit()
                            .padding(.trailing, 6)
                            .frame(width: detailItemWidth)
                        VStack(alignment: .leading) {
                            Text(todo.weather?.weather.description ?? "알수 없음")
                            HStack {
                                Text(viewModel.temperatureFormatter(todo.weather?.maxTemp))
                                    .foregroundStyle(.red)
                                Text(viewModel.temperatureFormatter(todo.weather?.minTemp))
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    HStack {
                        Text("강수 확률")
                            .frame(width: detailItemWidth, alignment: .leading)
                            .fontWeight(detailSubtitleFontWeight)
                        Text(viewModel.precipitationChanceFormatter(todo.weather?.precipitationChance))
                    }
                    HStack {
                        Text("UV 지수")
                            .frame(width: detailItemWidth, alignment: .leading)
                            .fontWeight(detailSubtitleFontWeight)
                        Text("\(todo.weather?.uvCategory.description ?? "")(\(todo.weather?.uvValue ?? 0))")
                    }
                } header: {
                    Text("날씨 상세 정보")
                        .font(.system(size: sectionFontSize, weight: detailTitleFontWeight))
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    TodoDetailView(todo: Todo.empty())
}

