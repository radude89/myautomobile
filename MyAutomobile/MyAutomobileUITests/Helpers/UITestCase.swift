//
//  UITestCase.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.02.2026.
//

import XCTest

@MainActor
class UITestCase: XCTestCase {
    private(set) var app: XCUIApplication!
    private(set) var supportedLocale: SupportedLocale!
    
    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        supportedLocale = SupportedLocale(systemLocale: .current)
        app = XCUIApplication()
        app.launchEnvironment["UITesting"] = "true"
    }
    
    override func tearDown() async throws {
        supportedLocale = nil
        app.terminate()
        try await super.tearDown()
    }
    
    func checkTabBarExists(line: UInt = #line) {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist", line: line)
    }
    
    func navigateTo(tab: Int, line: UInt = #line) {
        let firstTab = app.tabBars.buttons.element(boundBy: tab)
        if firstTab.exists {
            firstTab.tap()
        } else {
            XCTFail("Tab at index \(tab) does not exist", line: line)
        }
    }
    
    func tapButton(_ accessibilityID: String, line: UInt = #line) {
        let button = app.buttons[accessibilityID]
        if button.exists {
            button.tap()
        } else {
            XCTFail("Button with id \(accessibilityID) does not exist", line: line)
        }
    }

    func enterText(in textField: XCUIElement, text: String) {
        textField.tap()
        textField.typeText(text)
    }
}
