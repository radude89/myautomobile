//
//  UnitMeasure.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.02.2024.
//

import Foundation

enum UnitMeasure {
    case kilometers
    case miles
    case liters
    case ukGallons
    case usGallons
    case litersPerKm
    case litersPer10Km
    case litersPer100Km
    case usMilesPerGallon
    case ukMilesPerGallon
    
    var measure: String {
        return switch self {
        case .kilometers: "km"
        case .miles: "miles"
        case .liters: "liters"
        case .ukGallons: "UK gallons"
        case .usGallons: "US gallons"
        case .litersPerKm: "L/km"
        case .litersPer10Km: "L/10 km"
        case .litersPer100Km: "L/100 km"
        case .usMilesPerGallon: "US mpg"
        case .ukMilesPerGallon: "UK mpg"
        }
    }
}
