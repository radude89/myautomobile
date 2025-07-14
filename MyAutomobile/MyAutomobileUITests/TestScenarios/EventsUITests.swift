import XCTest

@MainActor
final class EventsUITests: XCTestCase, Sendable {
    // MARK: - Properties

    private var app: XCUIApplication!
    private var supportedLocale: SupportedLocale!

    // MARK: - Setup
    
    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        supportedLocale = SupportedLocale(systemLocale: .current)
        app = XCUIApplication()
        app.launchEnvironment["UITesting"] = "true"
        app.launch()
    }
    
    override func tearDown() async throws {
        supportedLocale = nil
        app.terminate()
        try await super.tearDown()
    }
    
    // MARK: - Tests
}

// MARK: - Helpers

private extension EventsUITests {
    
}
