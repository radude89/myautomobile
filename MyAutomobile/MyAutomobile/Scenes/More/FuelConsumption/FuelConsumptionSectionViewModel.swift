//
//  FuelConsumptionSectionViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.02.2024.
//

import Foundation

struct FuelConsumptionSectionViewModel {
    let units: [UnitMeasure]
    let fieldPlaceholder: String
    let sectionTitle: String
    
    var enteredAmount = ""
    var unitIndex = 0
    
    var currentUnit: UnitMeasure {
        units[unitIndex]
    }
}

extension FuelConsumptionSectionViewModel {
    static let distanceUnits: [UnitMeasure] = [.kilometers, .miles]
    static let usageUnits: [UnitMeasure] = [.liters, .usGallons, .ukGallons]
    static let consumptionUnits: [UnitMeasure] = [.litersPerKm, .litersPer10Km, .litersPer100Km, .usMilesPerGallon, .ukMilesPerGallon]

    static let distance = Self(
        units: distanceUnits,
        fieldPlaceholder: "Enter your travel distance in",
        sectionTitle: "Travel distance"
    )
    
    static let usage = Self(
        units: usageUnits,
        fieldPlaceholder: "Enter your fuel usage in",
        sectionTitle: "Fuel usage"
    )
    
    static let consumption = Self(
        units: consumptionUnits,
        fieldPlaceholder: "Enter your fuel consumption in",
        sectionTitle: "Fuel consumption"
    )
}
