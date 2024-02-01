//
//  ExpenseTrackingMoreItemViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import Observation

@Observable
final class ExpenseTrackingMoreItemViewModel {
    let vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
}
