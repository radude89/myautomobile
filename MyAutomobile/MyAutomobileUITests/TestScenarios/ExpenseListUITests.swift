//
//  ExpenseListUITests.swift
//  MyAutomobile
//
//  Created by Radu Dan on 09.02.2026.
//

import XCTest
import AccessibilityIdentifiers
import UITestEnvironment

final class ExpenseListUITests: UITestCase {
    override func setUp() async throws {
        try await super.setUp()
        app.launchEnvironment[UITestEnvironment.Key.vehicles] = ResourceLoader.json(
            supportedLocale: supportedLocale,
            resource: .vehicles
        )
        app.launchEnvironment[UITestEnvironment.Key.expenses] = ResourceLoader.json(
            supportedLocale: supportedLocale,
            resource: .expenses
        )
        app.launch()
    }

    func testExpensesFlowMultiLanguage() throws {
        checkTabBarExists()
        navigateTo(tab: .more)
        tapButton(MenuViewElements.ExpenseTrackingItem.id)
        try tapOnFirstVehicle()
        takeScreenshot("07")
        tapButton(ExpensesViewElements.Selector.Chart.id)
        tapRepairSegment()
        Thread.sleep(forTimeInterval: 1.0) // to finish-up the animation
        takeScreenshot("08")
    }
}

// MARK: - Private

private extension ExpenseListUITests {
    func tapOnFirstVehicle() throws {
        let firstVehiclePlate = try XCTUnwrap(expenses.first?.vehiclePlate)
        tapButton(firstVehiclePlate)
    }
    
    func tapRepairSegment() {
        let segmentID = AccessibilityIdentifiers.ExpensesViewElements.ChartView.Segment.id
        let expenseTypeID = ExpenseType.repair.rawValue
        app.otherElements["\(segmentID)-\(expenseTypeID)"].tap()
    }
}
