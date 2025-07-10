//
//  UITestingConfiguration.swift
//  MyAutomobile
//
//  Created by Claude Code on 07.07.2025.
//

import Foundation
import SwiftUI

class UITestingConfiguration: ObservableObject {
    static let shared = UITestingConfiguration()
    
    @Published var isUITesting: Bool = false
    @Published var currentLocale: String = "en"
    @Published var mockVehicles: [Vehicle] = []
    @Published var mockEvents: [Event] = []
    @Published var mockExpenses: [Expense] = []
    @Published var mockLandmark: MockLandmark?
    @Published var localizedStrings: [String: String] = [:]
    
    private init() {
        setupUITestingIfNeeded()
    }
    
    private func setupUITestingIfNeeded() {
        let environment = ProcessInfo.processInfo.environment
        
        // Check if we're in UI testing mode
        if environment["UITesting"] == "true" {
            isUITesting = true
            loadMockData(from: environment)
        }
    }
    
    private func loadMockData(from environment: [String: String]) {
        // Set locale
        if let locale = environment["AppLocale"] {
            currentLocale = locale
        }
        
        // Load mock vehicles
        if let vehicleData = environment["VehicleData"] {
            mockVehicles = parseVehicles(from: vehicleData)
        }
        
        // Load mock events
        if let eventData = environment["EventData"] {
            mockEvents = parseEvents(from: eventData)
        }
        
        // Load mock expenses
        if let expenseData = environment["ExpenseData"] {
            mockExpenses = parseExpenses(from: expenseData)
        }
        
        // Load landmark data
        if let landmarkData = environment["LandmarkData"] {
            mockLandmark = parseLandmark(from: landmarkData)
        }
        
        // Load localized strings
        if let stringsData = environment["LocalizedStringData"] {
            localizedStrings = parseLocalizedStrings(from: stringsData)
        }
    }
    
    private func parseVehicles(from jsonString: String) -> [Vehicle] {
        guard let data = jsonString.data(using: .utf8),
              let vehicleDataArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return []
        }
        
        return vehicleDataArray.compactMap { vehicleData in
            guard let plate = vehicleData["plate"] as? String,
                  let make = vehicleData["make"] as? String,
                  let model = vehicleData["model"] as? String,
                  let colorHex = vehicleData["color"] as? String else {
                return nil
            }
            
            // Parse color from hex string
            let color = Color(hex: colorHex) ?? Color.blue
            
            // Parse custom fields
            var customFieldsDict: [String: Vehicle.FieldDetails] = [:]
            if let customFields = vehicleData["customFields"] as? [String: String] {
                for (key, value) in customFields {
                    customFieldsDict[key] = Vehicle.FieldDetails(
                        dateCreated: Date(),
                        key: key,
                        value: value
                    )
                }
            }
            
            let vehicle = Vehicle(
                id: UUID(),
                make: make,
                model: model,
                numberPlate: plate,
                color: color,
                customFields: customFieldsDict,
                dateCreated: Date(),
                events: [],
                expenses: []
            )
            
            return vehicle
        }
    }
    
    private func parseEvents(from jsonString: String) -> [Event] {
        guard let data = jsonString.data(using: .utf8),
              let eventDataArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return []
        }
        
        return eventDataArray.compactMap { eventData in
            guard let descriptionKey = eventData["description_key"] as? String,
                  let vehicleRef = eventData["vehicle"] as? String,
                  let recurrenceKey = eventData["recurrence_key"] as? String,
                  let dateString = eventData["date"] as? String else {
                return nil
            }
            
            // Get localized description
            let description = localizedStrings[descriptionKey] ?? descriptionKey
            
            // Parse date
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            // Map recurrence
            let recurrence = mapRecurrence(from: recurrenceKey)
            
            return Event(
                id: UUID(),
                localCalendarID: nil,
                date: date,
                description: description,
                recurrence: recurrence
            )
        }
    }
    
    private func parseExpenses(from jsonString: String) -> [Expense] {
        guard let data = jsonString.data(using: .utf8),
              let expenseDataArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return []
        }
        
        return expenseDataArray.compactMap { expenseData in
            guard let categoryKey = expenseData["category_key"] as? String,
                  let amount = expenseData["amount"] as? Double,
                  let vehicleRef = expenseData["vehicle"] as? String,
                  let dateString = expenseData["date"] as? String else {
                return nil
            }
            
            // Map category
            let expenseType = mapExpenseCategory(from: categoryKey)
            
            // Parse date
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            return Expense(
                id: UUID(),
                date: date,
                odometerReading: nil,
                expenseType: expenseType,
                cost: amount,
                comment: nil
            )
        }
    }
    
    private func parseLandmark(from jsonString: String) -> MockLandmark? {
        guard let data = jsonString.data(using: .utf8),
              let landmarkData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let latitude = landmarkData["latitude"] as? Double,
              let longitude = landmarkData["longitude"] as? Double,
              let zoom = landmarkData["zoom"] as? Double else {
            return nil
        }
        
        let locationName = landmarkData["locationName"] as? String ?? ""
        
        return MockLandmark(
            latitude: latitude,
            longitude: longitude,
            zoom: zoom,
            locationName: locationName
        )
    }
    
    private func parseLocalizedStrings(from jsonString: String) -> [String: String] {
        guard let data = jsonString.data(using: .utf8),
              let stringsData = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            return [:]
        }
        
        return stringsData
    }
    
    private func mapRecurrence(from key: String) -> Event.Recurrence {
        switch key {
        case "recurrence_onetime":
            return .once
        case "recurrence_monthly":
            return .monthly
        case "recurrence_quarterly":
            return .quarterly
        case "recurrence_yearly":
            return .yearly
        default:
            return .once
        }
    }
    
    private func mapExpenseCategory(from key: String) -> ExpenseType {
        switch key {
        case "expense_repair":
            return .repair
        case "expense_fuel":
            return .fuel
        case "expense_insurance":
            return .insurance
        case "expense_maintenance":
            return .maintenance
        case "expense_other":
            return .other
        default:
            return .other
        }
    }
}

// MARK: - Mock Data Structures
struct MockLandmark {
    let latitude: Double
    let longitude: Double
    let zoom: Double
    let locationName: String
}

// MARK: - Color Extension for Hex Parsing
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}