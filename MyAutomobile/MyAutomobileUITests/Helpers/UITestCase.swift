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
    
    private(set) lazy var vehicles = VehiclesLoader.load(supportedLocale: supportedLocale)
    private(set) lazy var events = EventsLoader.load(supportedLocale: supportedLocale)
    private(set) lazy var expenses = ExpensesLoader.load(supportedLocale: supportedLocale)
    
    enum Tab: Int {
        case vehicles
        case events
        case parking
        case more
    }
    
    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        supportedLocale = SupportedLocale(systemLocale: .current)
        app = XCUIApplication()
        app.launchEnvironment[UITestEnvironment.Key.testing] = "true"
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
    
    func navigateTo(tab: Tab, file: StaticString = #filePath, line: UInt = #line) {
        let firstTab = app.tabBars.buttons.element(boundBy: tab.rawValue)
        if firstTab.exists {
            firstTab.tap()
        } else {
            XCTFail("Tab at index \(tab) does not exist", file: file, line: line)
        }
    }
    
    func tapButton(_ accessibilityID: String, file: StaticString = #filePath, line: UInt = #line) {
        let button = app.buttons[accessibilityID]
        if button.exists {
            button.tap()
        } else {
            XCTFail("Button with id \(accessibilityID) does not exist", file: file, line: line)
        }
    }
}
