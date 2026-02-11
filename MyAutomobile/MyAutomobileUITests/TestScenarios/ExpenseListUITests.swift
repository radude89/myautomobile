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
    private let shouldTakeScreenshot = false

    override func setUp() async throws {
        try await super.setUp()
        app.launchEnvironment[UITestEnvironment.Key.vehicles] = ResourceLoader.json(
            supportedLocale: supportedLocale,
            resource: .vehicles
        )
        app.launch()
    }

    func testExpensesFlowMultiLanguage() throws {
        try performExpensesFlow()
//
//        let app = XCUIApplication()
//        app.activate()
//        app/*@START_MENU_TOKEN@*/.images["gear"]/*[[".buttons[\"More\"].images",".buttons",".images[\"settings\"]",".images[\"gear\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Expense tracking"]/*[[".buttons",".containing(.staticText, identifier: \"Expense tracking\")",".containing(.image, identifier: \"pencil.line\")",".otherElements.buttons[\"Expense tracking\"]",".buttons[\"Expense tracking\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["A"]/*[[".buttons.containing(.staticText, identifier: \"A\")",".otherElements.buttons[\"A\"]",".buttons[\"A\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Chart"]/*[[".segmentedControls.buttons[\"Chart\"]",".buttons[\"Chart\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["List"]/*[[".segmentedControls.buttons[\"List\"]",".buttons[\"List\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Add Item"]/*[[".navigationBars.buttons[\"Add Item\"]",".buttons[\"Add Item\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.textFields["Odometer reading (optional)"]/*[[".otherElements.textFields[\"Odometer reading (optional)\"]",".textFields[\"Odometer reading (optional)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.textFields["Odometer reading (optional)"]/*[[".otherElements",".textFields[\"15000\"]",".textFields[\"Odometer reading (optional)\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("15000")
//        
//        let element = app/*@START_MENU_TOKEN@*/.buttons["Date Picker"]/*[[".datePickers",".buttons",".buttons[\"Date Picker\"]"],[[[-1,2],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
//        element.tap()
//        app.windows.element(boundBy: 1).tap()
//        element.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Wednesday, February 4"]/*[[".buttons.containing(.staticText, identifier: \"4\")",".collectionViews.buttons[\"Wednesday, February 4\"]",".buttons[\"Wednesday, February 4\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
    }
}

// MARK: - Private

private extension ExpenseListUITests {
    func performExpensesFlow() throws {
        checkTabBarExists()
        navigateTo(tab: .more)
        tapButton(MenuViewElements.ExpenseTrackingItem.id)
        try tapOnFirstVehicle()
        
    }
    
    func tapOnFirstVehicle() throws {
        let firstVehiclePlate = try XCTUnwrap(expenses.first?.vehiclePlate)
        tapButton(firstVehiclePlate)
    }
}
