//
//  MoreViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import Foundation

@MainActor
@Observable
final class MoreViewModel {
    private(set) var vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
}
