//
//  VehicleDetailsViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.08.2023.
//

import SwiftUI

final class VehicleDetailsViewModel: ObservableObject {
    @Published private var vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
    }
    
    var vehicleMake: String { vehicle.make }

    var vehicleModel: String { vehicle.model }

    var vehicleColor: Color { vehicle.color }

    var vehicleNumberPlate: String { vehicle.numberPlate }

    var customFields: [String: Vehicle.FieldDetails] { vehicle.customFields }
    
    func updateCustomField(labelText: String, valueText: String) {
        let newKey = UUID().uuidString
        vehicle.customFields[newKey] = Vehicle.FieldDetails(
            dateCreated: Date(),
            key: labelText,
            value: valueText
        )
    }
    
    func deleteFields(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = sortedValues[index]
            vehicle.customFields.removeValue(forKey: item.key)
        }
    }
    
    private var sortedValues: [(key: String, value: Vehicle.FieldDetails)] {
        customFields.sorted(by: >)
    }
}
