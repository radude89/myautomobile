import XCTest

extension XCUIElement {
    func dismissKeyboard() {
        typeText("\n")
    }

    func clearText() {
        guard let text = value as? String, !text.isEmpty else {
            return
        }

        text.forEach { _ in typeText(XCUIKeyboardKey.delete.rawValue) }
    }
}
