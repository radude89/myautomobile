//
//  FuelCalculatorUITests.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.02.2026.
//

import XCTest
import AccessibilityIdentifiers

final class FuelCalculatorUITests: UITestCase {
    func testFuelCalculator() {
        app.launch()
        checkTabBarExists()
        navigateTo(tab: .more)
        tapButton(MenuViewElements.FuelCalculatorItem.id)
        enterValues()
        tapOnCalculate()
        takeScreenshot("09")
    }
}

// MARK: - Private

private extension FuelCalculatorUITests {
    func enterValues() {
        let textFields = app.textFields
        textFields.element(boundBy: 0).enterText("10")
        textFields.element(boundBy: 1).enterText("50")
    }
    
    func tapOnCalculate() {
        app.buttons[FuelCalculatorViewElements.CalculateButton.id].tap()
    }
}
