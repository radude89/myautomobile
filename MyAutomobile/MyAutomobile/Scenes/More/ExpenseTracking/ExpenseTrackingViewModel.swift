//
//  ExpenseTrackingViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

final class ExpenseTrackingViewModel: ObservableObject {
    @ObservedObject var vehicles: Vehicles
    private(set) var vehicle: Vehicle
    
    init(vehicles: Vehicles, vehicle: Vehicle) {
        self.vehicles = vehicles
        self.vehicle = vehicle
    }
    
    var shouldDisplayEdit: Bool {
        true
    }
    
    var hasDeletedVehicle: Bool {
        !vehicles.items.contains(vehicle)
    }
}
