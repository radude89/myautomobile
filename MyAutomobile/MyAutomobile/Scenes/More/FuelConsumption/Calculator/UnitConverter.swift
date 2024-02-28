//
//  UnitConverter.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.02.2024.
//

import Foundation

enum UnitConverter {
    static func convertToLiters(
        _ value: Double,
        from unit: UnitMeasure
    ) -> Double {
        switch unit {
        case .ukGallons:
            value * ConversionFactor.litersToUkGal
        case .usGallons:
            value * ConversionFactor.litersToUsGal
        default:
            value
        }
    }
    
    static func convertToKilometers(
        _ value: Double,
        from unit: UnitMeasure
    ) -> Double {
        switch unit {
        case .miles:
            value * ConversionFactor.milesToKm
        default:
            value
        }
    }
    
    static func convertToMiles(
        _ value: Double,
        from unit: UnitMeasure
    ) -> Double {
        switch unit {
        case .kilometers:
            value * ConversionFactor.kmToMiles
        default:
            value
        }
    }
    
    static func convertToLitersPerKm(
        _ value: Double,
        from unit: UnitMeasure
    ) -> Double {
        return switch unit {
        case .litersPer10Km:
            value / ConversionFactor.litersTo10
        case .litersPer100Km:
            value / ConversionFactor.litersTo100
        case .usMilesPerGallon:
            ConversionFactor.usMiles / value
        case .ukMilesPerGallon:
            ConversionFactor.ukMiles / value
        default:
            value
        }
    }
}
