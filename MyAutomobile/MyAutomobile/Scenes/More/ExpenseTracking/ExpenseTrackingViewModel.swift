//
//  ExpenseTrackingViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

final class ExpenseTrackingViewModel: ObservableObject {
    @ObservedObject var vehicles: Vehicles
    let vehicleID: UUID
    
    init(vehicles: Vehicles, vehicleID: UUID) {
        self.vehicles = vehicles
        self.vehicleID = vehicleID
    }
    
    var shouldDisplayEdit: Bool {
        // TODO: Change to actual business logic
        true
    }
    
    var hasDeletedVehicle: Bool {
        !vehicles.items.contains { $0.id == vehicleID }
    }
    
}
