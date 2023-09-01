//
//  Vehicles.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.08.2023.
//

import Foundation

final class Vehicles: ObservableObject {
    private static let storageKey = "vehicles"
    @Published var items: [Vehicle] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
//                UserDefaults.standard.set(encoded, forKey: "vehicles")
                print(items)
            }
        }
    }
    
    init() {
        items = .demoVehicles
        return
        guard let itemsAsData = UserDefaults.standard.data(forKey: Self.storageKey) else {
            items = []
            return
        }
        
        items = Self.decodedVehicles(from: itemsAsData)
    }
}

private extension Vehicles {
    static func decodedVehicles(from itemsAsData: Data) -> [Vehicle] {
        guard let decoded = try? JSONDecoder().decode([Vehicle].self, from: itemsAsData) else {
            return []
        }
        
        return decoded.sorted(by: { v1, v2 in
            v1.dateCreated < v2.dateCreated
        })
    }
}
