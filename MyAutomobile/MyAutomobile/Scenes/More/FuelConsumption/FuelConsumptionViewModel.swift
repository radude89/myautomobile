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
    
    func calculateValues() {
        guard canCalculate else {
            return
        }

        calculateFuelUsageOrConsumptionIfPossible()
        calculateDistanceIfPossible()
    }
}

// MARK: - Private

private extension FuelConsumptionViewModel {
    func calculateFuelUsageOrConsumptionIfPossible() {
        guard let distanceInKm = distanceViewModel.amountInKm else {
            return
        }
        
        calculateConsumptionIfPossible(distanceInKm: distanceInKm)
        calculateFuelUsageIfPossible(distanceInKm: distanceInKm)
    }
    
    func calculateConsumptionIfPossible(distanceInKm: Double) {
        guard let fuelUsageInLiters =  usageViewModel.amountInLiters else {
            return
        }
        
        updateConsumptionAmount(
            distanceInKm: distanceInKm,
            fuelUsageInLiters: fuelUsageInLiters
        )
    }
    
    func calculateFuelUsageIfPossible(distanceInKm: Double) {
        guard let consumptionInLitersPerKm = consumptionViewModel.amountAsLitersPerKm else {
            return
        }
        
        updateUsageAmount(
            distanceInKm: distanceInKm,
            consumptionInLitersPerKm: consumptionInLitersPerKm
        )
    }
    
    func calculateDistanceIfPossible() {
        guard let fuelUsageInLiters = usageViewModel.amountInLiters,
              let consumptionInLitersPerKm = consumptionViewModel.amountAsLitersPerKm else {
            return
        }

        updateDistanceAmount(
            fuelUsageInLiters: fuelUsageInLiters,
            consumptionInLitersPerKm: consumptionInLitersPerKm
        )
    }
    
    func updateConsumptionAmount(
        distanceInKm: Double,
        fuelUsageInLiters: Double
    ) {
        let consumption = FieldCalculator.calculateConsumption(
            distanceInKm: distanceInKm,
            usageInLiters: fuelUsageInLiters,
            unit: consumptionViewModel.currentUnit
        )
        consumptionViewModel.setAmount(consumption)
    }
    
    func updateUsageAmount(
        distanceInKm: Double,
        consumptionInLitersPerKm: Double
    ) {
        let usage = FieldCalculator.calculateUsage(
            distanceInKm: distanceInKm,
            consumptionInLitersPerKm: consumptionInLitersPerKm,
            unit: usageViewModel.currentUnit
        )
        usageViewModel.setAmount(usage)
    }
    
    func updateDistanceAmount(
        fuelUsageInLiters: Double,
        consumptionInLitersPerKm: Double
    ) {
        let distance = FieldCalculator.calculateDistance(
            usageInLiters: fuelUsageInLiters,
            consumptionInLitersPerKm: consumptionInLitersPerKm,
            unit: distanceViewModel.currentUnit
        )
        distanceViewModel.setAmount(distance)
    }
}
