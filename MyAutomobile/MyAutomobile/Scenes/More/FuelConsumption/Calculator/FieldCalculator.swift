//
//  FieldCalculator.swift
//  MyAutomobile
//
//  Created by Radu Dan on 27.02.2024.
//

import Foundation

enum FieldCalculator {
    private typealias ConversionFactor = UnitConverter.ConversionFactor

    static func calculateConsumption(
        distanceInKm: Double,
        usageInLiters: Double,
        unit: UnitMeasure
    ) -> Double {
        let litersPerKm = usageInLiters / distanceInKm
        return switch unit {
        case .litersPer10Km:
            litersPerKm * ConversionFactor.litersTo10
        case .litersPer100Km:
            litersPerKm * ConversionFactor.litersTo100
        case .usMilesPerGallon:
            ConversionFactor.usMiles / litersPerKm
        case .ukMilesPerGallon:
            ConversionFactor.ukMiles / litersPerKm
        default:
            litersPerKm
        }
    }
    
    static func calculateUsage(
        distanceInKm: Double,
        consumptionInLitersPerKm: Double,
        unit: UnitMeasure
    ) -> Double {
        let usageInLiters = consumptionInLitersPerKm * distanceInKm
        return switch unit {
        case .ukGallons:
            usageInLiters / ConversionFactor.litersToUkGal
        case .usGallons:
            usageInLiters / ConversionFactor.litersToUsGal
        default:
            usageInLiters
        }
    }
    
    static func calculateDistance(
        usageInLiters: Double,
        consumptionInLitersPerKm: Double,
        unit: UnitMeasure
    ) -> Double {
        let distanceInKm = usageInLiters / consumptionInLitersPerKm
        return switch unit {
        case .miles:
            distanceInKm.toMiles(from: .kilometers)
        default:
            distanceInKm
        }
    }
}
