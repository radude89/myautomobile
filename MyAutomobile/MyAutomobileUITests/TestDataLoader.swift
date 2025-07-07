//
//  TestDataLoader.swift
//  MyAutomobileUITests
//
//  Created by Claude Code on 07.07.2025.
//

import Foundation
import XCTest

struct TestDataLoader {
    
    // MARK: - Load All Mock Data for Locale
    static func loadAllMockData(for locale: String) -> [String: String] {
        var mockData: [String: String] = [:]
        
        // Load vehicles data
        if let vehiclesData = loadVehiclesData(for: locale) {
            mockData["VehicleData"] = vehiclesData
        }
        
        // Load events data
        if let eventsData = loadEventsData() {
            mockData["EventData"] = eventsData
        }
        
        // Load expenses data
        if let expensesData = loadExpensesData() {
            mockData["ExpenseData"] = expensesData
        }
        
        // Load landmarks data
        if let landmarksData = loadLandmarksData(for: locale) {
            mockData["LandmarkData"] = landmarksData
        }
        
        // Load localized strings
        if let localizedStringsData = loadLocalizedStringsData(for: locale) {
            mockData["LocalizedStringData"] = localizedStringsData
        }
        
        return mockData
    }
    
    // MARK: - Load Vehicles Data
    static func loadVehiclesData(for locale: String) -> String? {
        guard let url = Bundle(for: MyAutomobileUITests.self).url(forResource: "vehicles", withExtension: "json", subdirectory: "MockData"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let vehiclesForLocale = json[locale] as? [[String: Any]] else {
            print("Failed to load vehicles data for locale: \(locale)")
            return nil
        }
        
        guard let vehiclesData = try? JSONSerialization.data(withJSONObject: vehiclesForLocale),
              let vehiclesString = String(data: vehiclesData, encoding: .utf8) else {
            return nil
        }
        
        return vehiclesString
    }
    
    // MARK: - Load Events Data
    static func loadEventsData() -> String? {
        guard let url = Bundle(for: MyAutomobileUITests.self).url(forResource: "events", withExtension: "json", subdirectory: "MockData"),
              let data = try? Data(contentsOf: url),
              let eventsString = String(data: data, encoding: .utf8) else {
            print("Failed to load events data")
            return nil
        }
        
        return eventsString
    }
    
    // MARK: - Load Expenses Data
    static func loadExpensesData() -> String? {
        guard let url = Bundle(for: MyAutomobileUITests.self).url(forResource: "expenses", withExtension: "json", subdirectory: "MockData"),
              let data = try? Data(contentsOf: url),
              let expensesString = String(data: data, encoding: .utf8) else {
            print("Failed to load expenses data")
            return nil
        }
        
        return expensesString
    }
    
    // MARK: - Load Landmarks Data
    static func loadLandmarksData(for locale: String) -> String? {
        guard let url = Bundle(for: MyAutomobileUITests.self).url(forResource: "landmarks", withExtension: "json", subdirectory: "MockData"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let landmarkForLocale = json[locale] as? [String: Any] else {
            print("Failed to load landmarks data for locale: \(locale)")
            return nil
        }
        
        guard let landmarkData = try? JSONSerialization.data(withJSONObject: landmarkForLocale),
              let landmarkString = String(data: landmarkData, encoding: .utf8) else {
            return nil
        }
        
        return landmarkString
    }
    
    // MARK: - Load Localized Strings Data
    static func loadLocalizedStringsData(for locale: String) -> String? {
        guard let url = Bundle(for: MyAutomobileUITests.self).url(forResource: "localizedStrings", withExtension: "json", subdirectory: "MockData"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let stringsForLocale = json[locale] as? [String: Any] else {
            print("Failed to load localized strings data for locale: \(locale)")
            return nil
        }
        
        guard let stringsData = try? JSONSerialization.data(withJSONObject: stringsForLocale),
              let stringsString = String(data: stringsData, encoding: .utf8) else {
            return nil
        }
        
        return stringsString
    }
    
    // MARK: - Date Calculation Helper
    static func calculateDate(from dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        let today = Date()
        let calendar = Calendar.current
        
        let calculatedDate: Date
        
        switch dateString {
        case "today":
            calculatedDate = today
        case "1_week_from_now":
            calculatedDate = calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today
        case "2_weeks_from_now":
            calculatedDate = calendar.date(byAdding: .weekOfYear, value: 2, to: today) ?? today
        case "1_month_from_now":
            calculatedDate = calendar.date(byAdding: .month, value: 1, to: today) ?? today
        case "3_months_from_now":
            calculatedDate = calendar.date(byAdding: .month, value: 3, to: today) ?? today
        case "6_months_from_now":
            calculatedDate = calendar.date(byAdding: .month, value: 6, to: today) ?? today
        case "1_week_ago":
            calculatedDate = calendar.date(byAdding: .weekOfYear, value: -1, to: today) ?? today
        case "2_weeks_ago":
            calculatedDate = calendar.date(byAdding: .weekOfYear, value: -2, to: today) ?? today
        case "3_days_ago":
            calculatedDate = calendar.date(byAdding: .day, value: -3, to: today) ?? today
        case "5_days_ago":
            calculatedDate = calendar.date(byAdding: .day, value: -5, to: today) ?? today
        case "1_month_ago":
            calculatedDate = calendar.date(byAdding: .month, value: -1, to: today) ?? today
        default:
            calculatedDate = today
        }
        
        return dateFormatter.string(from: calculatedDate)
    }
    
    // MARK: - Process Events Data with Calculated Dates
    static func processEventsData() -> String? {
        guard let eventsDataString = loadEventsData(),
              let eventsData = eventsDataString.data(using: .utf8),
              var eventsArray = try? JSONSerialization.jsonObject(with: eventsData) as? [[String: Any]] else {
            return nil
        }
        
        // Process each event to calculate actual dates
        for i in 0..<eventsArray.count {
            if let dateString = eventsArray[i]["date"] as? String {
                eventsArray[i]["date"] = calculateDate(from: dateString)
            }
        }
        
        guard let processedData = try? JSONSerialization.data(withJSONObject: eventsArray),
              let processedString = String(data: processedData, encoding: .utf8) else {
            return nil
        }
        
        return processedString
    }
    
    // MARK: - Process Expenses Data with Calculated Dates
    static func processExpensesData() -> String? {
        guard let expensesDataString = loadExpensesData(),
              let expensesData = expensesDataString.data(using: .utf8),
              var expensesArray = try? JSONSerialization.jsonObject(with: expensesData) as? [[String: Any]] else {
            return nil
        }
        
        // Process each expense to calculate actual dates
        for i in 0..<expensesArray.count {
            if let dateString = expensesArray[i]["date"] as? String {
                expensesArray[i]["date"] = calculateDate(from: dateString)
            }
        }
        
        guard let processedData = try? JSONSerialization.data(withJSONObject: expensesArray),
              let processedString = String(data: processedData, encoding: .utf8) else {
            return nil
        }
        
        return processedString
    }
}

// MARK: - Test Helper Extensions
extension TestDataLoader {
    
    // MARK: - Setup App for Testing
    static func setupApp(for locale: String) -> XCUIApplication {
        let app = XCUIApplication()
        
        // Set test mode
        app.launchEnvironment["UITesting"] = "true"
        app.launchEnvironment["AppLocale"] = locale
        
        // Load and set mock data
        let mockData = loadAllMockData(for: locale)
        for (key, value) in mockData {
            app.launchEnvironment[key] = value
        }
        
        // Set processed data with calculated dates
        if let processedEvents = processEventsData() {
            app.launchEnvironment["EventData"] = processedEvents
        }
        
        if let processedExpenses = processExpensesData() {
            app.launchEnvironment["ExpenseData"] = processedExpenses
        }
        
        return app
    }
    
    // MARK: - Launch App for Testing
    static func launchApp(for locale: String) -> XCUIApplication {
        let app = setupApp(for: locale)
        app.launch()
        return app
    }
}