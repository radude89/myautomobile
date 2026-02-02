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
        app.launch()
    }
    
    override func tearDown() async throws {
        supportedLocale = nil
        app.terminate()
        try await super.tearDown()
    }
}
