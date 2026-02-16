//
//  UITestCase.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.02.2026.
//

import XCTest
import UITestEnvironment

@MainActor
class UITestCase: XCTestCase {
    private(set) var app: XCUIApplication!
    private(set) var supportedLocale: SupportedLocale!
    
    private(set) lazy var vehicles = VehiclesLoader.load(supportedLocale: supportedLocale)
    private(set) lazy var events = EventsLoader.load(supportedLocale: supportedLocale)
    private(set) lazy var expenses = ExpensesLoader.load(supportedLocale: supportedLocale)
    
    private static let shouldTakeScreenshot = false
    
    // On iPad, use the system image identifiers - tap the first match to avoid duplicate button issues
    private let tabIdentifiers = ["car.2.fill", "calendar", "parkingsign", "gear"]

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
    
    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    func checkTabBarExists(file: StaticString = #filePath, line: UInt = #line) {
        if isIPad {
            let navigationExists = tabIdentifiers.contains { identifier in
                app.buttons.matching(identifier: identifier).count > 0
            }
            XCTAssertTrue(navigationExists, "Navigation should exist", file: file, line: line)
        } else {
            let tabBar = app.tabBars.firstMatch
            XCTAssertTrue(tabBar.exists, "Tab bar should exist", file: file, line: line)
        }
    }
    
    func navigateTo(tab: Tab, file: StaticString = #filePath, line: UInt = #line) {
        if isIPad {
            handleIPadNavigation(tab: tab, file: file, line: line)
        } else {
            handlePhoneNavigation(tab: tab, file: file, line: line)
        }
    }
    
    private func handleIPadNavigation(tab: Tab, file: StaticString = #filePath, line: UInt = #line) {
        let buttons = app.buttons.matching(identifier: tabIdentifiers[tab.rawValue])
        if buttons.count > 0 {
            buttons.firstMatch.tap()
        } else {
            XCTFail("Navigation button with identifier '\(tabIdentifiers[tab.rawValue])' does not exist", file: file, line: line)
        }
    }
    
    private func handlePhoneNavigation(tab: Tab, file: StaticString = #filePath, line: UInt = #line) {
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
    
    func takeScreenshot(_ label: String) {
        guard Self.shouldTakeScreenshot else { return }
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "\(supportedLocale.rawValue)-\(label)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
