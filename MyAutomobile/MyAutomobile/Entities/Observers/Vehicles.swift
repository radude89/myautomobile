//
//  Vehicles.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.08.2023.
//

import SwiftUI

final class Vehicles: ObservableObject {
    @Published var items: [Vehicle] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
//                UserDefaults.standard.set(encoded, forKey: "vehicles")
                print(items)
            }
        }
    }
    
    init() {
        if let itemsAsData = UserDefaults.standard.data(forKey: "vehicles") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([Vehicle].self, from: itemsAsData) {
                self.items = decoded.sorted(by: { v1, v2 in
                    v1.dateCreated < v2.dateCreated
                })
                return
            }
        }
        
        items = .demoVehicles
    }
}
