//
//  UITestHelpers.swift
//  MyAutomobileUITests
//
//  Created by Claude Code on 07.07.2025.
//

import XCTest
import AccessibilityIdentifiers

extension XCTestCase {
    
    // MARK: - Screenshot Utilities
    func takeScreenshot(named name: String, locale: String = "en") {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "\(name)_\(locale.uppercased())"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func takeScreenshot(named name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    // MARK: - Wait Utilities
    func waitForElementToExist(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func waitForElementToBeHittable(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "isHittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    // MARK: - Navigation Utilities
    func selectTab(_ tabIdentifier: String, in app: XCUIApplication) {
        let tabBarButton = app.tabBars.buttons[tabIdentifier]
        XCTAssertTrue(waitForElementToBeHittable(tabBarButton), "Tab \(tabIdentifier) should be hittable")
        tabBarButton.tap()
    }
    
    func navigateToVehiclesTab(in app: XCUIApplication) {
        selectTab(TabBarElements.VehiclesTab.id, in: app)
    }
    
    func navigateToEventsTab(in app: XCUIApplication) {
        selectTab(TabBarElements.EventsTab.id, in: app)
    }
    
    func navigateToParkingTab(in app: XCUIApplication) {
        selectTab(TabBarElements.ParkingTab.id, in: app)
    }
    
    func navigateToMoreTab(in app: XCUIApplication) {
        selectTab(TabBarElements.MoreTab.id, in: app)
    }
    
    // MARK: - Vehicle Operations
    func tapAddVehicleButton(in app: XCUIApplication) {
        let addButton = app.buttons[VehicleListViewElements.AddButton.id]
        XCTAssertTrue(waitForElementToBeHittable(addButton), "Add vehicle button should be hittable")
        addButton.tap()
    }
    
    func fillVehicleForm(plate: String, state: String, make: String, model: String, in app: XCUIApplication) {
        let plateField = app.textFields[VehicleAddViewElements.PlateTextField.id]
        let stateField = app.textFields[VehicleAddViewElements.StateTextField.id]
        let makeField = app.textFields[VehicleAddViewElements.MakeTextField.id]
        let modelField = app.textFields[VehicleAddViewElements.ModelTextField.id]
        
        XCTAssertTrue(waitForElementToExist(plateField), "Plate field should exist")
        plateField.tap()
        plateField.typeText(plate)
        
        stateField.tap()
        stateField.typeText(state)
        
        makeField.tap()
        makeField.typeText(make)
        
        modelField.tap()
        modelField.typeText(model)
    }
    
    func selectVehicleColor(in app: XCUIApplication) {
        let colorPickerRow = app.buttons[VehicleAddViewElements.ColorPickerRow.id]
        XCTAssertTrue(waitForElementToBeHittable(colorPickerRow), "Color picker row should be hittable")
        colorPickerRow.tap()
    }
    
    func saveVehicle(in app: XCUIApplication) {
        let doneButton = app.buttons[VehicleAddViewElements.DoneButton.id]
        XCTAssertTrue(waitForElementToBeHittable(doneButton), "Done button should be hittable")
        doneButton.tap()
    }
    
    func selectFirstVehicle(in app: XCUIApplication) {
        let vehicleCell = app.cells[VehicleListViewElements.VehicleCell.id].firstMatch
        XCTAssertTrue(waitForElementToBeHittable(vehicleCell), "First vehicle cell should be hittable")
        vehicleCell.tap()
    }
    
    // MARK: - Custom Field Operations
    func addCustomField(name: String, value: String, in app: XCUIApplication) {
        let addFieldButton = app.buttons[VehicleDetailViewElements.AddFieldButton.id]
        XCTAssertTrue(waitForElementToBeHittable(addFieldButton), "Add field button should be hittable")
        addFieldButton.tap()
        
        let nameField = app.textFields[VehicleDetailViewElements.CustomFieldNameTextField.id]
        let valueField = app.textFields[VehicleDetailViewElements.CustomFieldValueTextField.id]
        
        XCTAssertTrue(waitForElementToExist(nameField), "Custom field name field should exist")
        nameField.tap()
        nameField.typeText(name)
        
        valueField.tap()
        valueField.typeText(value)
        
        // Assuming there's a save button or similar action
        app.keyboards.buttons["Return"].tap()
    }
    
    // MARK: - Fuel Calculator Operations
    func navigateToFuelCalculator(in app: XCUIApplication) {
        navigateToMoreTab(in: app)
        let fuelCalculatorRow = app.cells[MoreViewElements.FuelCalculatorRow.id]
        XCTAssertTrue(waitForElementToBeHittable(fuelCalculatorRow), "Fuel calculator row should be hittable")
        fuelCalculatorRow.tap()
    }
    
    func fillFuelCalculatorForm(distance: String, usage: String, in app: XCUIApplication) {
        let distanceField = app.textFields[FuelCalculatorViewElements.DistanceTextField.id]
        let usageField = app.textFields[FuelCalculatorViewElements.UsageTextField.id]
        
        XCTAssertTrue(waitForElementToExist(distanceField), "Distance field should exist")
        distanceField.tap()
        distanceField.typeText(distance)
        
        usageField.tap()
        usageField.typeText(usage)
    }
    
    func getConsumptionResult(in app: XCUIApplication) -> String {
        let resultLabel = app.staticTexts[FuelCalculatorViewElements.ResultLabel.id]
        XCTAssertTrue(waitForElementToExist(resultLabel), "Result label should exist")
        return resultLabel.label
    }
    
    // MARK: - Expense Operations
    func navigateToExpenseTracking(in app: XCUIApplication) {
        navigateToMoreTab(in: app)
        let expenseTrackingRow = app.cells[MoreViewElements.ExpenseTrackingRow.id]
        XCTAssertTrue(waitForElementToBeHittable(expenseTrackingRow), "Expense tracking row should be hittable")
        expenseTrackingRow.tap()
    }
    
    func selectChartView(in app: XCUIApplication) {
        let chartSegmentedControl = app.segmentedControls[ExpenseTrackingViewElements.ChartSegmentedControl.id]
        XCTAssertTrue(waitForElementToExist(chartSegmentedControl), "Chart segmented control should exist")
        chartSegmentedControl.buttons.element(boundBy: 0).tap() // Assuming chart is first option
    }
    
    // MARK: - Parking Operations
    func waitForMapToLoad(in app: XCUIApplication, timeout: TimeInterval = 10.0) {
        let mapView = app.maps[ParkingViewElements.MapView.id]
        XCTAssertTrue(waitForElementToExist(mapView, timeout: timeout), "Map view should exist and load")
        
        // Additional wait for map to fully render
        Thread.sleep(forTimeInterval: 2.0)
    }
    
    func verifyParkingMarkerExists(in app: XCUIApplication) -> Bool {
        let parkingMarker = app.otherElements[ParkingViewElements.ParkingMarker.id]
        return parkingMarker.exists
    }
    
    // MARK: - Assertion Utilities
    func assertElementExists(_ element: XCUIElement, message: String = "") {
        XCTAssertTrue(waitForElementToExist(element), message.isEmpty ? "Element should exist" : message)
    }
    
    func assertElementIsHittable(_ element: XCUIElement, message: String = "") {
        XCTAssertTrue(waitForElementToBeHittable(element), message.isEmpty ? "Element should be hittable" : message)
    }
    
    func assertElementContainsText(_ element: XCUIElement, text: String, message: String = "") {
        XCTAssertTrue(waitForElementToExist(element), "Element should exist before checking text")
        XCTAssertTrue(element.label.contains(text), message.isEmpty ? "Element should contain text '\(text)'" : message)
    }
    
    func assertVehicleExists(withPlate plate: String, in app: XCUIApplication) {
        let vehicleCell = app.cells.containing(NSPredicate(format: "label CONTAINS '\(plate)'"))
        XCTAssertTrue(vehicleCell.firstMatch.exists, "Vehicle with plate '\(plate)' should exist in the list")
    }
    
    func assertCustomFieldExists(name: String, value: String, in app: XCUIApplication) {
        let customFieldRow = app.cells.containing(NSPredicate(format: "label CONTAINS '\(name): \(value)'"))
        XCTAssertTrue(customFieldRow.firstMatch.exists, "Custom field '\(name): \(value)' should exist")
    }
}