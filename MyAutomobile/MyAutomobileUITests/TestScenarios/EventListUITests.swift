import XCTest
import AccessibilityIdentifiers
import UITestEnvironment

final class EventListUITests: UITestCase {
    override func setUp() async throws {
        try await super.setUp()
        app.launchEnvironment[UITestEnvironment.Key.vehicles] = ResourceLoader.json(
            supportedLocale: supportedLocale,
            resource: .vehicles
        )
        app.launch()
    }

    func testEventsFlowMultiLanguage() {
        performEventsFlow()
    }
}

// MARK: - Private

private extension EventListUITests {
    func performEventsFlow() {
        checkTabBarExists()
        navigateTo(tab: .events)

        events.enumerated().forEach { index, event in
            tapButton(EventListViewElements.AddButton.id)
            takeFirstScreenshot(index: index)
            turnOffSyncWithLocalCalendar()
            enterEventDetails(event)
            selectDate(for: event)
            setEventRecurrence(event)
            selectVehicle(for: event)
            tapOnDoneFromAddCustomFieldNavigationBar()
            confirmAlert()
            takeLastScreenshot(index: index, eventsCount: events.count)
        }
    }
    
    func takeFirstScreenshot(index: Int) {
        guard index == 0 else { return }
        takeScreenshot("05")
    }
    
    func takeLastScreenshot(index: Int, eventsCount: Int) {
        guard index == eventsCount - 1 else { return }
        takeScreenshot("06")
    }
    
    func turnOffSyncWithLocalCalendar() {
        let toggle = app.switches.element(boundBy: app.switches.count - 1)
        toggle.tap()
    }
    
    func enterEventDetails(_ event: EventTestData) {
        let descriptionTextField = app.textFields.element(boundBy: 0)
        descriptionTextField.enterText(event.title)
        descriptionTextField.dismissKeyboard()
    }
    
    func selectDate(for event: EventTestData) {
        guard event.occurrence != .today else { return }

        tapOnDatePicker()
        selectDate(daysFromToday: event.occurrence.inDays)
        dismissPopup()
    }
    
    func tapOnDatePicker() {
        app.datePickers[EventListViewElements.AddView.DatePicker.id].buttons.element(boundBy: 0).tap()
    }

    func selectDate(daysFromToday: Int, line: UInt = #line) {
        let calendar = Calendar.current
        guard let targetDate = calendar.date(byAdding: .day, value: daysFromToday, to: Date()) else {
            XCTFail("Failed to calculate target date for offset: \(daysFromToday)", line: line)
            return
        }

        let datePicker = app.datePickers.firstMatch
        datePicker.navigateToMonth(targetDate: targetDate)
        datePicker.tapDay(targetDate)
    }
    
    func dismissPopup() {
        app.buttons["PopoverDismissRegion"].tap()
    }
    
    func setEventRecurrence(_ event: EventTestData) {
        guard event.recurrence != .oneTime else { return }

        app.buttons[EventListViewElements.AddView.RecurrencePicker.id].tap()
        app.collectionViews.element(boundBy: 0).buttons.element(boundBy: event.recurrence.rawValue).tap()
    }
    
    func selectVehicle(for event: EventTestData) {
        let selectVehicleButton = app.buttons[EventListViewElements.AddView.VehiclePicker.id]
        guard !selectVehicleButton.label.contains(event.vehiclePlate) else { return }
        
        selectVehicleButton.tap()
        app.buttons.matching(NSPredicate(format: "label == %@", event.vehiclePlate)).firstMatch.tap()
    }
    
    func tapOnDoneFromAddCustomFieldNavigationBar() {
        app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 1).tap()
    }
    
    func confirmAlert() {
        app.alerts.firstMatch.buttons.firstMatch.tap()
    }
}
