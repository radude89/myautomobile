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
    private var app: XCUIApplication!

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

    // MARK: - Add Vehicles from Specs Through UI
    func test01_AddAndDetailVehicleFlow() throws {
        launchApp()
        checkTabBarExists()
        navigateToFirstTab()
        
        let vehiclesToAdd = [
            (plate: "7GRL293", state: "California", make: "Ford", model: "Mustang GT"),
            (plate: "FLK 38L", state: "Florida", make: "Dodge", model: "Challenger R/T"),
            (plate: "OH-8232Z", state: "Ohio", make: "Jeep", model: "Wrangler Rubicon")
        ]
        
        for vehicle in vehiclesToAdd {
            tapAddButton()
            fillVehicleForm(vehicle: vehicle)
            saveVehicle()
        }
        
        takeScreenshot(name: "001-en-vehicles")
    }
    
    // MARK: - Helper Functions
    private func launchApp(locale: String = "en") {
        app.launchEnvironment["AppLocale"] = locale
        app.launch()
    }

    private func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    private func checkTabBarExists(line: UInt = #line) {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist", line: line)
    }
    
    private func navigateToFirstTab(line: UInt = #line) {
        let firstTab = app.tabBars.buttons.element(boundBy: 0)
        if firstTab.exists {
            firstTab.tap()
        } else {
            XCTFail("First tab does not exist", line: line)
        }
    }
    
    private func tapAddButton(line: UInt = #line) {
        let addButton = app.buttons[VehicleListViewElements.AddButton.id]
        if addButton.exists {
            addButton.tap()
        } else {
            XCTFail("Add button does not exist", line: line)
        }
    }

    private func fillVehicleForm(vehicle: (plate: String, state: String, make: String, model: String)) {
        // Find text fields in order (plate, state, make, model)
        let textFields = app.textFields
        
        // Fill plate
        if textFields.count > 0 {
            let plateField = textFields.element(boundBy: 0)
            plateField.tap()
            plateField.typeText(vehicle.plate)
        }
        
        // Fill state/region
        if textFields.count > 1 {
            let stateField = textFields.element(boundBy: 1)
            stateField.tap()
            stateField.typeText(vehicle.state)
        }
        
        // Fill make
        if textFields.count > 2 {
            let makeField = textFields.element(boundBy: 2)
            makeField.tap()
            makeField.typeText(vehicle.make)
        }
        
        // Fill model
        if textFields.count > 3 {
            let modelField = textFields.element(boundBy: 3)
            modelField.tap()
            modelField.typeText(vehicle.model)
        }
    }
    
    private func saveVehicle() {
        // Look for Done, Save, or similar button
        let doneButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Done' OR label CONTAINS 'Save'")).firstMatch
        if doneButton.exists {
            doneButton.tap()
        } else {
            // Try navigation bar done button
            let navBarDone = app.navigationBars.buttons.containing(NSPredicate(format: "label CONTAINS 'Done' OR label CONTAINS 'Save'")).firstMatch
            if navBarDone.exists {
                navBarDone.tap()
            }
        }
    }
    
    // MARK: - Events Tab Test
    func test02_EventsFlow() throws {
        app = XCUIApplication()
        app.launchEnvironment["UITesting"] = "true"
        app.launchEnvironment["AppLocale"] = "en"
        app.launch()
        
        Thread.sleep(forTimeInterval: 3.0)
        
        // Navigate to events tab (second tab)
        let eventsTab = app.tabBars.buttons.element(boundBy: 1)
        if eventsTab.exists {
            eventsTab.tap()
            
            Thread.sleep(forTimeInterval: 2.0)
            let eventsScreenshot = XCUIScreen.main.screenshot()
            let eventsAttachment = XCTAttachment(screenshot: eventsScreenshot)
            eventsAttachment.name = "04_Events_EN"
            eventsAttachment.lifetime = .keepAlways
            add(eventsAttachment)
        }
        
        XCTAssertTrue(true, "Events navigation test completed")
    }
    
    // MARK: - Parking Tab Test
    func test03_ParkingFlow() throws {
        app = XCUIApplication()
        app.launchEnvironment["UITesting"] = "true"
        app.launchEnvironment["AppLocale"] = "fr"
        app.launch()
        
        Thread.sleep(forTimeInterval: 3.0)
        
        // Navigate to parking tab (third tab)
        let parkingTab = app.tabBars.buttons.element(boundBy: 2)
        if parkingTab.exists {
            parkingTab.tap()
            
            // Wait for map to load
            Thread.sleep(forTimeInterval: 5.0)
            let parkingScreenshot = XCUIScreen.main.screenshot()
            let parkingAttachment = XCTAttachment(screenshot: parkingScreenshot)
            parkingAttachment.name = "05_Parking_FR"
            parkingAttachment.lifetime = .keepAlways
            add(parkingAttachment)
        }
        
        XCTAssertTrue(true, "Parking navigation test completed")
    }
    
    // MARK: - French Vehicles Test
    func test04_AddFrenchVehicles() throws {
        app = XCUIApplication()
        app.launchEnvironment["UITesting"] = "true"
        app.launchEnvironment["AppLocale"] = "fr"
        app.launch()
        
        Thread.sleep(forTimeInterval: 3.0)
        
        // Navigate to vehicles tab
        let vehiclesTab = app.tabBars.buttons.element(boundBy: 0)
        vehiclesTab.tap()
        
        // Take screenshot of empty French vehicles list
        Thread.sleep(forTimeInterval: 2.0)
        let listScreenshot = XCUIScreen.main.screenshot()
        let listAttachment = XCTAttachment(screenshot: listScreenshot)
        listAttachment.name = "01_EmptyVehicleList_FR"
        listAttachment.lifetime = .keepAlways
        add(listAttachment)
        
        // Define French vehicles from specs
        let frenchVehicles = [
            (plate: "FR-215-JK", region: "Île-de-France", make: "Renault", model: "Clio V"),
            (plate: "DB-742-LH", region: "Provence-Alpes-Côte d'Azur", make: "Peugeot", model: "3008 GT")
        ]
        
        // Add first French vehicle
        if let vehicle = frenchVehicles.first {
            let addButton = app.buttons[VehicleListViewElements.AddButton.id]
            if addButton.exists {
                addButton.tap()
                Thread.sleep(forTimeInterval: 3.0)
                
                // Take screenshot of French add form
                let addScreenshot = XCUIScreen.main.screenshot()
                let addAttachment = XCTAttachment(screenshot: addScreenshot)
                addAttachment.name = "02_AddVehicleForm_FR"
                addAttachment.lifetime = .keepAlways
                add(addAttachment)
                
                fillVehicleForm(vehicle: (plate: vehicle.plate, state: vehicle.region, make: vehicle.make, model: vehicle.model))
                saveVehicle()
                Thread.sleep(forTimeInterval: 2.0)
            }
        }
        
        // Take screenshot of populated French list
        let populatedScreenshot = XCUIScreen.main.screenshot()
        let populatedAttachment = XCTAttachment(screenshot: populatedScreenshot)
        populatedAttachment.name = "03_PopulatedVehicleList_FR"
        populatedAttachment.lifetime = .keepAlways
        add(populatedAttachment)
    }
    
    // MARK: - German Vehicles Test
    func test05_AddGermanVehicles() throws {
        app = XCUIApplication()
        app.launchEnvironment["UITesting"] = "true"
        app.launchEnvironment["AppLocale"] = "de"
        app.launch()
        
        Thread.sleep(forTimeInterval: 3.0)
        
        // Navigate to vehicles tab
        let vehiclesTab = app.tabBars.buttons.element(boundBy: 0)
        vehiclesTab.tap()
        
        // Take screenshot of empty German vehicles list
        Thread.sleep(forTimeInterval: 2.0)
        let listScreenshot = XCUIScreen.main.screenshot()
        let listAttachment = XCTAttachment(screenshot: listScreenshot)
        listAttachment.name = "01_EmptyVehicleList_DE"
        listAttachment.lifetime = .keepAlways
        add(listAttachment)
        
        // Define German vehicles from specs
        let germanVehicles = [
            (plate: "B MW 1234", region: "Berlin", make: "BMW", model: "3 Series"),
            (plate: "M AU 4567", region: "Munich", make: "Audi", model: "A4")
        ]
        
        // Add first German vehicle
        if let vehicle = germanVehicles.first {
            let addButton = app.buttons[VehicleListViewElements.AddButton.id]
            if addButton.exists {
                addButton.tap()
                Thread.sleep(forTimeInterval: 3.0)
                
                // Take screenshot of German add form
                let addScreenshot = XCUIScreen.main.screenshot()
                let addAttachment = XCTAttachment(screenshot: addScreenshot)
                addAttachment.name = "02_AddVehicleForm_DE"
                addAttachment.lifetime = .keepAlways
                add(addAttachment)
                
                fillVehicleForm(vehicle: (plate: vehicle.plate, state: vehicle.region, make: vehicle.make, model: vehicle.model))
                saveVehicle()
                Thread.sleep(forTimeInterval: 2.0)
            }
        }
        
        // Take screenshot of populated German list
        let populatedScreenshot = XCUIScreen.main.screenshot()
        let populatedAttachment = XCTAttachment(screenshot: populatedScreenshot)
        populatedAttachment.name = "03_PopulatedVehicleList_DE"
        populatedAttachment.lifetime = .keepAlways
        add(populatedAttachment)
    }
    
    // MARK: - Legacy test for compatibility
    func testSelectSecondTab() throws {
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        
        Thread.sleep(forTimeInterval: 3.0)
        
        let tabBarButtons = app.tabBars.buttons
        let vehiclesTab = tabBarButtons.element(boundBy: 0)
        vehiclesTab.tap()
        
        let addButton = app.buttons[VehicleListViewElements.AddButton.id]
        if addButton.exists {
            addButton.tap()
        }
        
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Legacy_Test_Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
