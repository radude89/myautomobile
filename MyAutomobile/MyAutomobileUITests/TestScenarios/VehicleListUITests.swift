import XCTest
import AccessibilityIdentifiers

final class VehicleListUITests: UITestCase {
    func testAddVehiclesAndShowDetailsFlowMultiLanguage() {
        app.launch()
        performVehiclesFlow()
    }
}

// MARK: - Helpers

private extension VehicleListUITests {
    func performVehiclesFlow() {
        checkTabBarExists()
        navigateTo(tab: .vehicles)
        addVehicles()
        takeScreenshot("01")
        tapFirstRow()
        tapAddFieldButton()
        addCustomVehicleField(locale: supportedLocale)
        tapOnDoneFromAddCustomFieldNavigationBar()
        takeScreenshot("04")
    }

    func addVehicles() {
        for (index, vehicle) in vehicles.enumerated() {
            addVehicle(vehicle, index: index)
        }
    }
    
    func addVehicle(_ vehicle: VehicleTestData, index: Int) {
        tapButton(VehicleListViewElements.AddButton.id)
        fillVehicleForm(vehicle: vehicle)
        setVehicleColor(color: vehicle.colorWithoutHash)
        takeVehicleScreenshotIfNeeded(index: index, name: "03")
        tapCloseButton()
        takeVehicleScreenshotIfNeeded(index: index, name: "02")
        tapDoneButton()
    }
    
    func takeVehicleScreenshotIfNeeded(index: Int,name: String) {
        guard index == 0 else { return }
        takeScreenshot(name)
    }
    
    func tapCloseButton() {
        tapButton("close")
    }

    func fillVehicleForm(vehicle: VehicleTestData, line: UInt = #line) {
        let textFields = app.textFields

        textFields.element(boundBy: 0).enterText(vehicle.plate)
        textFields.element(boundBy: 1).enterText(vehicle.make)
        
        let modelField = textFields.element(boundBy: 2)
        modelField.enterText(vehicle.model)
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
        nameField.enterText(nameText)
        
        let valueField = app.textFields[
            AccessibilityIdentifiers.VehicleDetailViewElements.CustomFieldValue.id
        ].firstMatch
        let valueText = LocalizedStringHelper.loadString(StringKey.gas.rawValue, locale: locale)
        valueField.enterText(valueText)
    }
    
    func tapOnDoneFromAddCustomFieldNavigationBar() {
        app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 1).tap()
    }
}
