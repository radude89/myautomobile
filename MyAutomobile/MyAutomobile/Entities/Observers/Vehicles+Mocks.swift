//
//  Vehicles+Mocks.swift
//  MyAutomobile
//
//  Created by Radu Dan on 07.07.2025.
//

import SwiftUI

extension Vehicles {
    static func loadMockData() -> [Vehicle] {
        guard let vehicleDataString = ProcessInfo.processInfo.environment["VehicleData"],
              let data = vehicleDataString.data(using: .utf8),
              let vehicleDataArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            print("Failed to load mock vehicle data")
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
            
            return Vehicle(
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
        }
    }
}

// MARK: - Color Extension for Hex Parsing
private extension Color {
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
