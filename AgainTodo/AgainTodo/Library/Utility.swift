
import Foundation
import SwiftUI



// MARK: Text
func numberTextLine(_ text: String, font: UIFont, maxWidth: CGFloat) -> Int {
    let stringSize = (text as NSString).boundingRect(
        with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading],
        attributes: [.font: font],
        context: nil
    ).size
    return Int(ceil(stringSize.height / font.lineHeight))
}
