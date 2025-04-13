
import Foundation

class TodoItemViewModel: ObservableObject {
    @Published var gridRatio:CGFloat = 0.3
    @Published var isChecked: Bool = false
    
    func dateFormatter(_ date:Date?) -> String {
        if date != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: date!)
        }
        else {
            return ""
        }
    }
}
