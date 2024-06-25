//
//  VehicleAddViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 24.08.2023.
//

import SwiftUI

@MainActor
final class VehicleAddViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
    
    func saveVehicle(numberPlate: String, makeText: String, modelText: String, color: Color) {
        let vehicle = Vehicle(make: makeText, model: modelText, numberPlate: numberPlate, color: color)
        vehicles.items.append(vehicle)
    }
    
}
