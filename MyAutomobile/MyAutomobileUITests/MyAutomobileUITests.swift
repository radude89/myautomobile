//
//  MyAutomobileUITests.swift
//  MyAutomobileUITests
//
//  Created by Radu Dan on 04.04.2022.
//

import XCTest
import AccessibilityIdentifiers

@MainActor
final class MyAutomobileUITests: XCTestCase, Sendable {
    private let mockVehicles = VehicleLoader.loadAll()
    private var app: XCUIApplication!

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() async throws {
        app.terminate()
        try await super.tearDown()
    }

    func testSelectSecondTab() throws {
        launchApp()
        selectFirstTab()
        tapAddButton()
//        let attachment = XCTAttachment(screenshot: app.screenshot())
//        attachment.name = "Parking Tab Selected"
//        attachment.lifetime = .keepAlways
//        add(attachment)
    }
}

private extension MyAutomobileUITests {
    func launchApp() {
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func selectFirstTab() {
        let tabBarButtons = app.tabBars.buttons
        let vehiclesTab = tabBarButtons.element(boundBy: 0)
        vehiclesTab.tap()
    }

    @discardableResult
    func tapAddButton() -> XCUIElement {
        let addButton = app.buttons[VehicleListViewElements.AddButton.id]
        addButton.tap()
        return addButton
    }

    @discardableResult
    func tapOnSliders() -> XCUIElement{
        let segmentedControl = app.segmentedControls.firstMatch
        let slidersTab = segmentedControl.buttons.element(boundBy: 2)
        slidersTab.tap()
        return slidersTab
    }
}
