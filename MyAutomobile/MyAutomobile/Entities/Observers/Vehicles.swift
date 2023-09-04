//
//  Vehicles.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.08.2023.
//

import Foundation

final class Vehicles: ObservableObject {
    
    @Published var items: [Vehicle]
    
    static let storageKey = "saved-vehicles"

    init() {
        items = Self.loadData()
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
