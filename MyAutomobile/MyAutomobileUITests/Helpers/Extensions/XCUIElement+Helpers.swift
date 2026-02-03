import XCTest

extension XCUIElement {
    func dismissKeyboard() {
        typeText("\n")
    }
    
    func clearText() {
        guard let stringValue = value as? String else {
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}
