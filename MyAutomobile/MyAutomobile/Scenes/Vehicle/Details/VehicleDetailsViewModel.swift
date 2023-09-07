//
//  VehicleDetailsViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.08.2023.
//

import SwiftUI

final class VehicleDetailsViewModel: ObservableObject {

    @Published private var vehicle: Vehicle
    @ObservedObject var vehicles: Vehicles
    
    init(vehicle: Vehicle, vehicles: Vehicles) {
        self.vehicle = vehicle
        self.vehicles = vehicles
    }
    
}

// MARK: - Getters
extension VehicleDetailsViewModel {
    var vehicleMake: String {
        vehicle.make
    }
    
    var vehicleModel: String {
        vehicle.model
    }
    
    var vehicleColor: Color {
        vehicle.color
    }
    
    var vehicleNumberPlate: String {
        vehicle.numberPlate
    }
    
    var customFields: [String: Vehicle.FieldDetails] {
        vehicle.customFields
    }
}

// MARK: - Setters
extension VehicleDetailsViewModel {
    func addCustomField(labelText: String, valueText: String) {
        let newKey = UUID().uuidString
        vehicle.customFields[newKey] = Vehicle.FieldDetails(
            dateCreated: Date(),
            key: labelText,
            value: valueText
        )
        updateVehicles()
    }
    
    private func updateVehicles() {
        var items = vehicles.items
        items.removeAll { $0.id == vehicle.id }
        items.append(vehicle)
        vehicles.items = items.sorted { $0.dateCreated < $1.dateCreated }
    }
    
    func deleteFields(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = sortedFields[index]
            vehicle.customFields.removeValue(forKey: item.key)
        }
        updateVehicles()
    }

    private var sortedFields: [(key: String, value: Vehicle.FieldDetails)] {
        customFields.sorted(by: >)
    }
    
    func set(text: String, keyPath: WritableKeyPath<Vehicle, String>) {
        guard !text.isEmpty else {
            return
        }
        guard vehicle[keyPath: keyPath] != text else {
            return
        }

        vehicle[keyPath: keyPath] = text
        updateVehicles()
    }
    
    func set(color: Color) {
        guard vehicle.color != color else {
            return
        }

        vehicle.color = color
        updateVehicles()
    }
}
