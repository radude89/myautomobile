import XCTest
import AccessibilityIdentifiers

@MainActor
final class VehicleUITests: XCTestCase, Sendable {
    // MARK: - Properties
    
    private var app: XCUIApplication!
    
    // MARK: - Setup
    
    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["UITesting"] = "true"
    }
    
    override func tearDown() async throws {
        app?.terminate()
        try await super.tearDown()
    }
    
    // MARK: - Tests
    
    func testAddVehiclesAndShowDetailsFlow() throws {
        launchApp()
        checkTabBarExists()
        navigateToFirstTab()
        
        for (index, vehicle) in VehicleLoader.load().enumerated() {
            tapAddButton()
            fillVehicleForm(vehicle: vehicle)
            setVehicleColor(color: vehicle.colorWithoutHash)
//            takeVehicleScreenshotIfNeeded(index: index, name: "us-03")
            tapCloseButton()
//            takeVehicleScreenshotIfNeeded(index: index, name: "us-02")
            tapDoneButton()
        }
        
//        takeScreenshot(name: "us-01")
        
        tapFirstRow()
        tapAddFieldButton()
        addCustomVehicleField()
        tapOnDoneFromAddCustomFieldNavigationBar()
        
//        takeScreenshot(name: "us-04")
    }
}

// MARK: - Helpers

private extension VehicleUITests {
    func launchApp(locale: String = "en") {
        app.launchEnvironment["AppLocale"] = locale
        app.launch()
    }

    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func takeVehicleScreenshotIfNeeded(index: Int, name: String) {
        guard index == 0 else { return }
        takeScreenshot(name: name)
    }
    
    func checkTabBarExists(line: UInt = #line) {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist", line: line)
    }
    
    func navigateToFirstTab(line: UInt = #line) {
        let firstTab = app.tabBars.buttons.element(boundBy: 0)
        if firstTab.exists {
            firstTab.tap()
        } else {
            XCTFail("First tab does not exist", line: line)
        }
    }
    
    func tapAddButton(line: UInt = #line) {
        let addButton = app.buttons[VehicleListViewElements.AddButton.id]
        if addButton.exists {
            addButton.tap()
        } else {
            XCTFail("Add button does not exist", line: line)
        }
    }
    
    func tapCloseButton() {
        app.buttons["close"].tap()
    }

    func fillVehicleForm(vehicle: VehicleTestData, line: UInt = #line) {
        let textFields = app.textFields
        guard textFields.count >= 3 else {
            XCTFail("We expected at least 3 text fields, but found \(textFields.count) instead.", line: line)
            return
        }
        
        enterText(in: textFields.element(boundBy: 0), text: vehicle.plate)
        enterText(in: textFields.element(boundBy: 1), text: vehicle.make)
        
        let modelField = textFields.element(boundBy: 2)
        enterText(in: modelField, text: vehicle.model)
        modelField.dismissKeyboard()
    }
    
    func enterText(in textField: XCUIElement, text: String) {
        textField.tap()
        textField.typeText(text)
    }
    
    func setVehicleColor(color: String) {
        app.colorWells.element(boundBy: 0).tap()
        let segmentedControl = app.segmentedControls.element(boundBy: 0)
        segmentedControl.buttons.element(boundBy: 2).tap()
        
        let colorTextField = app.textFields.element(boundBy: 6).firstMatch
        colorTextField.tap()
        colorTextField.clearText()
        colorTextField.typeText(color)
        colorTextField.dismissKeyboard()
        
        segmentedControl.buttons.element(boundBy: 0).tap()
    }

    func tapDoneButton() {
        let addView = app.otherElements[VehicleAddViewElements.View.id]
        let navBar = addView.navigationBars.element(boundBy: 0)
        let doneButton = navBar.buttons.element(boundBy: 1)
        doneButton.tap()
    }
    
    func tapFirstRow() {
        app.cells.element(boundBy: 0).tap()
    }
    
    func tapAddFieldButton() {
        app.buttons[
            AccessibilityIdentifiers.VehicleDetailViewElements.AddFieldButton.id
        ].tap()
    }
    
    func addCustomVehicleField() {
        let nameField = app.textFields[
            AccessibilityIdentifiers.VehicleDetailViewElements.CustomFieldName.id
        ].firstMatch
        enterText(in: nameField, text: String(localized: "Fuel"))
        
        let valueField = app.textFields[
            AccessibilityIdentifiers.VehicleDetailViewElements.CustomFieldValue.id
        ].firstMatch
        enterText(in: valueField, text: String(localized: "Gas"))
    }
    
    func tapOnDoneFromAddCustomFieldNavigationBar() {
        app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 1).tap()
    }
}
