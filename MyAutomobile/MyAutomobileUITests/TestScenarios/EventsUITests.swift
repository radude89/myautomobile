import XCTest

final class EventsUITests: UITestCase {
    func testEventsFlowMultiLanguage() {
        performEventsFlow(shouldTakeScreenshot: false)
    }
}

// MARK: - Private

private extension EventsUITests {
    func performEventsFlow(shouldTakeScreenshot: Bool = false) {
        let events = EventsLoader.load(supportedLocale: supportedLocale)
        
    }
}
