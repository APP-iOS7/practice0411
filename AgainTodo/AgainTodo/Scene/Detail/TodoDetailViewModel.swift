

import Foundation

final class TodoDetailViewModel: ObservableObject {
    
    
    func dateFormatter(_ date: Date?) -> String {
        if date != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date!)
        }
        else { return "" }
    }
    
    func temperatureFormatter(_ temperature: Double?) -> String {
        if temperature != nil {
            return String(format: "%.1f°C", temperature!)
        }
        else { return "" }
    }
    
    func precipitationChanceFormatter(_ precipitationChance: Double?) -> String {
        if precipitationChance != nil {
            return String(format: "%.0f%%", precipitationChance!)
        }
        else { return "" }
    }
}
