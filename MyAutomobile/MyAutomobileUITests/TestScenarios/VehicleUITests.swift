import XCTest
import AccessibilityIdentifiers

final class VehicleUITests: UITestCase {
    private let numberOfVehicles = 3
    
    func testAddVehiclesAndShowDetailsFlowMultiLanguage() {
        app.launch()
        performVehiclesFlow(shouldTakeScreenshot: false)
    }
}

// MARK: - Helpers

private extension VehicleUITests {
    func performVehiclesFlow(shouldTakeScreenshot: Bool = false) {
        checkTabBarExists()
        navigateTo(tab: 0)
        addVehicles(shouldTakeScreenshots: shouldTakeScreenshot)
        takeScreenshotIfNeeded(
            name: "\(supportedLocale.rawValue)-01",
            shouldTakeScreenshot: shouldTakeScreenshot
        )
        tapFirstRow()
        tapAddFieldButton()
        addCustomVehicleField(locale: supportedLocale)
        tapOnDoneFromAddCustomFieldNavigationBar()
        takeScreenshotIfNeeded(
            name: "\(supportedLocale.rawValue)-04",
            shouldTakeScreenshot: shouldTakeScreenshot
        )
    }
    
    func addVehicles(shouldTakeScreenshots: Bool) {
        let vehicles = VehiclesLoader.load(supportedLocale: supportedLocale)
        for (index, vehicle) in vehicles.enumerated() {
            addVehicle(
                vehicle,
                index: index,
                shouldTakeScreenshot: shouldTakeScreenshots
            )
        }
    }
    
    func addVehicle(
        _ vehicle: VehicleTestData,
        index: Int,
        shouldTakeScreenshot: Bool
    ) {
        tapButton(VehicleListViewElements.AddButton.id)
        fillVehicleForm(vehicle: vehicle)
        setVehicleColor(color: vehicle.colorWithoutHash)
        takeVehicleScreenshotIfNeeded(
            index: index,
            name: "\(supportedLocale.rawValue)-03",
            shouldTakeScreenshot: shouldTakeScreenshot
        )
        tapCloseButton()
        takeVehicleScreenshotIfNeeded(
            index: index,
            name: "\(supportedLocale.rawValue)-02",
            shouldTakeScreenshot: shouldTakeScreenshot
        )
        tapDoneButton()
    }
    
    func takeScreenshotIfNeeded(name: String, shouldTakeScreenshot: Bool) {
        guard shouldTakeScreenshot else { return }
        takeScreenshot(name: name)
    }
    
    func takeVehicleScreenshotIfNeeded(
        index: Int,
        name: String,
        shouldTakeScreenshot: Bool
    ) {
        guard index == 0 else { return }
        takeScreenshotIfNeeded(name: name, shouldTakeScreenshot: shouldTakeScreenshot)
    }
    
    func tapCloseButton() {
        tapButton("close")
    }

    func fillVehicleForm(vehicle: VehicleTestData, line: UInt = #line) {
        let textFields = app.textFields
        guard textFields.count >= numberOfVehicles else {
            XCTFail(
                "We expected at least \(numberOfVehicles) text fields, but found \(textFields.count) instead.",
                line: line
            )
            return
        }
        
        enterText(in: textFields.element(boundBy: 0), text: vehicle.plate)
        enterText(in: textFields.element(boundBy: 1), text: vehicle.make)
        
        let modelField = textFields.element(boundBy: 2)
        enterText(in: modelField, text: vehicle.model)
        modelField.dismissKeyboard()
    }
    
    func setVehicleColor(color: String) {
        tapButton(VehicleAddViewElements.View.ColorPicker.id)
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
        tapButton(AccessibilityIdentifiers.VehicleDetailViewElements.AddFieldButton.id)
    }
    
    func addCustomVehicleField(locale: SupportedLocale = .english) {
        let nameField = app.textFields[
            AccessibilityIdentifiers.VehicleDetailViewElements.CustomFieldName.id
        ].firstMatch
        let nameText = LocalizedStringHelper.loadString(StringKey.fuel.rawValue, locale: locale)
        enterText(in: nameField, text: nameText)
        
        let valueField = app.textFields[
            AccessibilityIdentifiers.VehicleDetailViewElements.CustomFieldValue.id
        ].firstMatch
        let valueText = LocalizedStringHelper.loadString(StringKey.gas.rawValue, locale: locale)
        enterText(in: valueField, text: valueText)
    }
    
    func tapOnDoneFromAddCustomFieldNavigationBar() {
        app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 1).tap()
    }
}
