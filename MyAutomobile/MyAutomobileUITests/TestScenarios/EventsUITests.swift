import XCTest
import AccessibilityIdentifiers

final class EventsUITests: UITestCase {
    override func setUp() async throws {
        try await super.setUp()
        app.launchEnvironment["VehicleData"] = VehiclesLoader.json(supportedLocale: .french)
        app.launch()
    }

    func testEventsFlowMultiLanguage() {
        performEventsFlow(shouldTakeScreenshot: false)
    }
}

// MARK: - Private

private extension EventsUITests {
    func performEventsFlow(shouldTakeScreenshot: Bool = false) {
        checkTabBarExists()
        navigateTo(tab: 1)
        tapButton(EventListViewElements.AddButton.id)
        turnOffSyncWithLocalCalendar()
        
        let events = EventsLoader.load(supportedLocale: supportedLocale)
        let firstEvent = events[0]
        let descriptionTextField = app.textFields.element(boundBy: 0)
        events.forEach { event in
            // Add event
        }
        
        enterText(in: descriptionTextField, text: firstEvent.title)
        descriptionTextField.dismissKeyboard()
        
        tapOnDatePicker()
        selectDate(daysFromToday: 14)
        
        dismissPopup()
        app.buttons[EventListViewElements.AddView.RecurrencePicker.id].tap()
        app.collectionViews.element(boundBy: 0).buttons.element(boundBy: 4).tap()

        app.buttons[EventListViewElements.AddView.VehiclePicker.id].tap()
        app.buttons.matching(NSPredicate(format: "label == %@", "DB-742-LH")).firstMatch.tap()
    }
    
    func turnOffSyncWithLocalCalendar() {
        let toggle = app.switches.element(boundBy: app.switches.count - 1)
        toggle.tap()
    }
    
    func tapOnDatePicker() {
        app.datePickers[EventListViewElements.AddView.DatePicker.id].buttons.element(boundBy: 0).tap()
    }

    func selectDateYesterday() {
        selectDate(daysFromToday: -1)
    }

    func selectDateTomorrow() {
        selectDate(daysFromToday: 1)
    }

    func selectDateNextWeek() {
        selectDate(daysFromToday: 7)
    }

    func selectDateInTwoWeeks() {
        selectDate(daysFromToday: 14)
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
}
