//
//  ExpenseTrackingMoreItemViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

final class ExpenseTrackingMoreItemViewModel: ObservableObject {
    @ObservedObject var vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
    
    var items: [Vehicle] {
        vehicles.items
    }
    
    var firstVehicle: Vehicle? {
        vehicles.items.first
    }
}
