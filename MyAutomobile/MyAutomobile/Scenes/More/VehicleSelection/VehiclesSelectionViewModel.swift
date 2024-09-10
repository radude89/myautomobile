//
//  VehiclesSelectionViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

@MainActor
final class VehiclesSelectionViewModel: ObservableObject {

    @ObservedObject var vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }

}
