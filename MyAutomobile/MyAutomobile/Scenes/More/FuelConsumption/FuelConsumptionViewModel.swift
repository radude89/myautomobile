//
//  FuelConsumptionViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 28.02.2024.
//

import SwiftUI

final class FuelConsumptionViewModel: ObservableObject {
    @Published var distanceViewModel: FuelConsumptionSectionViewModel = .distance
    @Published var usageViewModel: FuelConsumptionSectionViewModel = .usage
    @Published var consumptionViewModel: FuelConsumptionSectionViewModel = .consumption
    
    func calculateValues() {
        if let distanceInKm = distanceViewModel.amountInKm, distanceInKm > 0 {
            if let fuelUsageInLiters = usageViewModel.amountInLiters {
                let consumption = FieldCalculator.calculateConsumption(
                    distanceInKm: distanceInKm,
                    usageInLiters: fuelUsageInLiters,
                    unit: consumptionViewModel.currentUnit
                )
                consumptionViewModel.setAmount(consumption)
            } else if let consumption = consumptionViewModel.amountAsDouble {
                let consumptionInLitersPerKm = UnitConverter.convertToLitersPerKm(
                    consumption,
                    from: consumptionViewModel.currentUnit
                )
                let usage = FieldCalculator.calculateUsage(
                    distanceInKm: distanceInKm,
                    consumptionInLitersPerKm: consumptionInLitersPerKm,
                    unit: usageViewModel.currentUnit
                )
                usageViewModel.setAmount(usage)
            }
        } else if let fuelUsageInLiters = usageViewModel.amountInLiters {
            if let consumption = consumptionViewModel.amountAsDouble, consumption > 0  {
                let consumptionInLitersPerKm = UnitConverter.convertToLitersPerKm(
                    consumption,
                    from: consumptionViewModel.currentUnit
                )
                let distance = FieldCalculator.calculateDistance(
                    usageInLiters: fuelUsageInLiters,
                    consumptionInLitersPerKm: consumptionInLitersPerKm,
                    unit: distanceViewModel.currentUnit
                )
                distanceViewModel.setAmount(distance)
            }
        }
    }
    
    var canCalculate: Bool {
        let distance = distanceViewModel.amountAsDouble
        let fuelUsage = usageViewModel.amountAsDouble
        let consumption = consumptionViewModel.amountAsDouble
        
        if distance == nil {
            return fuelUsage != nil && consumption != nil
        }
        
        if fuelUsage == nil {
            return distance != nil && consumption != nil
        }
        
        if consumption == nil {
            return distance != nil && fuelUsage != nil
        }
        
        return true
    }
}
