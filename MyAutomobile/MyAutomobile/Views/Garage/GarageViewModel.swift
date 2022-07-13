//
//  GarageViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import Foundation

final class GarageViewModel: ObservableObject {
    
    @Published private(set) var vehicles: [Vehicle]
    
    init(vehicles: [Vehicle] = .demoVehicles) {
        self.vehicles = vehicles
    }
    
    var hasVehicles: Bool {
        vehicles.isEmpty
    }
    
    func delete(atOffsets offsets: IndexSet) {
        vehicles.remove(atOffsets: offsets)
    }
    
}
