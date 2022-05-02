//
//  GarageViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import Foundation

final class GarageViewModel: ObservableObject {
    
    private(set) var vehicles: [Vehicle]
    
    init(vehicles: [Vehicle] = []) {
        self.vehicles = vehicles
    }
    
    var hasVehicles: Bool {
        vehicles.isEmpty
    }
    
}
