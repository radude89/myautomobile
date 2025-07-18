//
//  Vehicles.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.08.2023.
//

import SwiftUI

final class Vehicles: ObservableObject {
    
    @Published var items: [Vehicle]
    
    static let storageKey = "saved-vehicles"

    init() {
        if ProcessInfo.processInfo.environment["UITesting"] == "true" {
            UserDefaults.standard.set(999, forKey: "vehicle-slots")
            items = Self.loadMockData()
        } else {
            items = Self.loadData()
        }
    }

}

private extension Vehicles {
    static func loadData() -> [Vehicle] {
        do {
            let data = try FileManager.readData(fileName: Self.storageKey)
            return try JSONDecoder()
                .decode([Vehicle].self, from: data)
                .sorted { $0.dateCreated < $1.dateCreated }
        } catch {
            print("Unable to load data, error: \(error.localizedDescription)")
        }
        
        return []
    }
}
