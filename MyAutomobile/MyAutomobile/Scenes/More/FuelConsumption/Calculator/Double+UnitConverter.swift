//
//  Double+UnitConverter.swift
//  MyAutomobile
//
//  Created by Radu Dan on 28.02.2024.
//

import Foundation

extension Double {
    func toKm(from unit: UnitMeasure) -> Double {
        UnitConverter.convertToKilometers(self, from: unit)
    }
    
    func toMiles(from unit: UnitMeasure) -> Double {
        UnitConverter.convertToMiles(self, from: unit)
    }
    
    func toLiters(from unit: UnitMeasure) -> Double {
        UnitConverter.convertToLiters(self, from: unit)
    }
}
