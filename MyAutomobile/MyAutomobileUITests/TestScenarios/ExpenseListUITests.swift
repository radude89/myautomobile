//
//  ExpenseListUITests.swift
//  MyAutomobile
//
//  Created by Radu Dan on 09.02.2026.
//

import XCTest

final class ExpenseListUITests: UITestCase {
    private let shouldTakeScreenshot = false

    override func setUp() async throws {
        try await super.setUp()
        app.launchEnvironment["VehicleData"] = VehiclesLoader.json(supportedLocale: supportedLocale)
        app.launch()
    }

    func testExpensesFlowMultiLanguage() {
        performExpensesFlow()
    }
}

// MARK: - Private

private extension ExpenseListUITests {
    func performExpensesFlow() {
        checkTabBarExists()
        navigateTo(tab: .more)
        // TODO: Select vehicle
    }
}
