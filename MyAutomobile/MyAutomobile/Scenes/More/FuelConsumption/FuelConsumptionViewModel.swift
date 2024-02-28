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

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    func calculateValues() {
        if let distanceInKm = numberFormatter
            .number(from: distanceViewModel.enteredAmount)?
            .doubleValue
            .toKm(from: distanceViewModel.currentUnit),
            distanceInKm > 0 {
            if let fuelUsageInLiters = numberFormatter
                .number(from: usageViewModel.enteredAmount)?
                .doubleValue
                .toLiters(from: usageViewModel.currentUnit) {
                let consumption = FieldCalculator.calculateConsumption(
                    distanceInKm: distanceInKm,
                    usageInLiters: fuelUsageInLiters,
                    unit: consumptionViewModel.currentUnit
                )
                consumptionViewModel.enteredAmount = numberFormatter.string(
                    from: NSNumber(value: consumption)
                ) ?? ""
            } else if let consumption = numberFormatter
                .number(from: consumptionViewModel.enteredAmount)?
                .doubleValue {
                let consumptionInLitersPerKm = UnitConverter.convertToLitersPerKm(
                    consumption,
                    from: consumptionViewModel.currentUnit
                )
                let usage = FieldCalculator.calculateUsage(
                    distanceInKm: distanceInKm,
                    consumptionInLitersPerKm: consumptionInLitersPerKm,
                    unit: usageViewModel.currentUnit
                )
                usageViewModel.enteredAmount = numberFormatter.string(
                    from: NSNumber(value: usage)
                ) ?? ""
            }
        } else if let fuelUsageInLiters = numberFormatter
            .number(from: usageViewModel.enteredAmount)?
            .doubleValue
            .toLiters(from: usageViewModel.currentUnit) {
            if let consumption = numberFormatter
                .number(from: consumptionViewModel.enteredAmount)?
                .doubleValue,
               consumption > 0  {
                let consumptionInLitersPerKm = UnitConverter.convertToLitersPerKm(
                    consumption,
                    from: consumptionViewModel.currentUnit
                )
                let distance = FieldCalculator.calculateDistance(
                    usageInLiters: fuelUsageInLiters,
                    consumptionInLitersPerKm: consumptionInLitersPerKm,
                    unit: distanceViewModel.currentUnit
                )
                distanceViewModel.enteredAmount = numberFormatter.string(
                    from: NSNumber(value: distance)
                ) ?? ""
            }
        }
    }
    
    var canCalculate: Bool {
        let distance = numberFormatter.number(from: distanceViewModel.enteredAmount)?.doubleValue
        let fuelUsage = numberFormatter.number(from: usageViewModel.enteredAmount)?.doubleValue
        let consumption = numberFormatter.number(from: consumptionViewModel.enteredAmount)?.doubleValue
        
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
