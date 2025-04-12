//TODO: font 정리

import SwiftUI

struct TodoDetailView: View {
    let todo: Todo
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("할 일")
                        .frame(width: 70, alignment: .leading)
                        .fontWeight(.semibold)
                    Text(todo.title)
                }
                HStack {
                    Text("상세 내용")
                        .frame(width: 70, alignment: .leading)
                        .fontWeight(.semibold)
                    Text(todo.detail)
                }
                HStack {
                    Text("마감일")
                        .frame(width: 70, alignment: .leading)
                        .fontWeight(.semibold)
                    Text(todo.deadline?.description ?? "")
                }
                HStack {
                    Text("완료 여부")
                        .frame(width: 70, alignment: .leading)
                        .fontWeight(.semibold)
                    Text(todo.isDone ? "Done" : "Not Done")
                }
            } header: {
                Text("할 일!")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .fontWeight(.black)
            }
            
            if todo.weather != nil {
                Section {
                    HStack {
                        Image(systemName: todo.weather?.icon ?? "camera.metering.unknown")
                            .resizable()
                            .scaledToFit()
                            .padding(.trailing, 6)
                            .frame(width: 70)
                        VStack(alignment: .leading) {
                            Text(todo.weather?.weather.description ?? "알수 없음")
                            HStack {
                                Text(todo.weather?.maxTemp.description ?? "")
                                    .foregroundStyle(.red)
                                Text(todo.weather?.minTemp.description ?? "")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    HStack {
                        Text("강수 확률")
                            .frame(width: 70, alignment: .leading)
                            .fontWeight(.semibold)
                        Text(todo.weather?.precipitationChance.description ?? "")
                    }
                    HStack {
                        Text("UV 지수")
                            .frame(width: 70, alignment: .leading)
                            .fontWeight(.semibold)
                        Text("\(todo.weather?.uvCategory.description ?? "")(\(todo.weather?.uvValue ?? 0))")
                    }
                } header: {
                    Text("날씨")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    TodoDetailView(todo: Todo.empty())
}

