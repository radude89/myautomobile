import XCTest
import AccessibilityIdentifiers

final class EventsUITests: UITestCase {
    override func setUp() async throws {
        try await super.setUp()
        app.launchEnvironment["VehicleData"] = VehiclesLoader.json(supportedLocale: supportedLocale)
        app.launch()
    }

    func testEventsFlowMultiLanguage() {
        performEventsFlow(shouldTakeScreenshot: false)
        
//        let app = XCUIApplication()
//        app.activate()
//        app/*@START_MENU_TOKEN@*/.images["calendar"]/*[[".buttons[\"Events\"].images",".buttons.images[\"calendar\"]",".images[\"calendar\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["plus"]/*[[".otherElements[\"plus\"].buttons",".otherElements",".buttons[\"Add\"]",".buttons[\"plus\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.textFields/*[[".otherElements.textFields[\"Description\"]",".textFields",".textFields[\"Description\"]"],[[[-1,2],[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".otherElements.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".otherElements.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".otherElements.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        
//        let element = app/*@START_MENU_TOKEN@*/.keys["f"]/*[[".otherElements.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
//        element.tap()
//        element.doubleTap()
//        element.tap()
//        app/*@START_MENU_TOKEN@*/.buttons.containing(.staticText, identifier: "A")/*[[".buttons.containing(.staticText, identifier: \"A\")",".otherElements.buttons[\"Vehicle, A\"]",".buttons[\"Vehicle, A\"]"],[[[-1,2],[-1,1],[-1,0]]],[2]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.otherElements["Horizontal scroll bar, 1 page"]/*[[".collectionViews.otherElements[\"Horizontal scroll bar, 1 page\"]",".otherElements[\"Horizontal scroll bar, 1 page\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        
//        let windowsQuery = app.windows
//        windowsQuery/*@START_MENU_TOKEN@*/.containing(.other, identifier: "SystemInputAssistantView").firstMatch/*[[".element(boundBy: 2)",".containing(.other, identifier: \"CenterPageView\").firstMatch",".containing(.keyboard, identifier: nil).firstMatch",".containing(.other, identifier: \"SystemInputAssistantView\").firstMatch"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
//        app/*@START_MENU_TOKEN@*/.buttons["Date Picker"]/*[[".datePickers",".buttons",".buttons[\"Date Picker\"]"],[[[-1,2],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Wednesday, February 4"]/*[[".buttons.containing(.staticText, identifier: \"4\")",".collectionViews.buttons[\"Wednesday, February 4\"]",".buttons[\"Wednesday, February 4\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.staticTexts["11"]/*[[".buttons[\"Wednesday, February 11\"].staticTexts",".otherElements.staticTexts[\"11\"]",".staticTexts[\"11\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Monday, February 9"]/*[[".buttons.containing(.staticText, identifier: \"9\")",".collectionViews.buttons[\"Monday, February 9\"]",".buttons[\"Monday, February 9\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        
//        let element2 = windowsQuery.element(boundBy: 1)
//        element2.tap()
//        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts",".buttons.staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        
//        let element3 = app/*@START_MENU_TOKEN@*/.staticTexts["Select date"]/*[[".otherElements.staticTexts[\"Select date\"]",".staticTexts[\"Select date\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
//        element3.swipeUp()
//        app/*@START_MENU_TOKEN@*/.staticTexts["One time"]/*[[".buttons[\"Recurrence, One time\"].staticTexts",".buttons.staticTexts[\"One time\"]",".staticTexts[\"One time\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Monthly"]/*[[".cells.buttons[\"Monthly\"]",".buttons[\"Monthly\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        element3.swipeUp()
//        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".otherElements",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.staticTexts["Monthly"]/*[[".buttons[\"Recurrence, Monthly\"].staticTexts",".buttons.staticTexts[\"Monthly\"]",".staticTexts[\"Monthly\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["One time"]/*[[".cells.buttons[\"One time\"]",".buttons[\"One time\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        element2.tap()
//        app.otherElements.element(boundBy: 12).tap()
//        element2.swipeDown()
//        app/*@START_MENU_TOKEN@*/.switches["1"]/*[[".switches.switches[\"1\"]",".switches[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.doubleTap()
//        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"Done\"].buttons",".otherElements.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["OK"]/*[[".otherElements.buttons[\"OK\"]",".buttons",".buttons[\"OK\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
//        
        
    }
}

// MARK: - Private

private extension EventsUITests {
    func performEventsFlow(shouldTakeScreenshot: Bool = false) {
        checkTabBarExists()
        navigateTo(tab: 1)

        // Add flow
        tapButton(EventListViewElements.AddButton.id)
        let events = EventsLoader.load(supportedLocale: supportedLocale)
        
        events.forEach { event in
            // Add event
        }
        
        let event = events[0]
        let descriptionTextField = app.textFields.element(boundBy: 0)
        enterText(in: descriptionTextField, text: "Test description")
        descriptionTextField.dismissKeyboard()
        
        let selectVehicleButton = app.buttons
            .containing(.staticText, identifier: event.vehiclePlate)
            .firstMatch
        selectVehicleButton.tap()
        
        
    }
}
