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
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var amountInKm: Double? {
        amountAsDouble?.toKm(from: currentUnit)
    }
    
    var amountAsDouble: Double? {
        numberFormatter.number(from: enteredAmount)?.doubleValue
    }
    
    var amountInLiters: Double? {
        amountAsDouble?.toLiters(from: currentUnit)
    }
    
    mutating func setAmount(_ doubleValue: Double) {
        enteredAmount = numberFormatter.string(
            from: NSNumber(value: doubleValue)
        ) ?? ""
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
