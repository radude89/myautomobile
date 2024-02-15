//
//  FuelConsumptionDetails.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.02.2024.
//

import Foundation

struct FuelConsumptionDetails {
    var unitIndex: Int
    var enteredAmount: String
    
    init(unitIndex: Int = 0,
         enteredAmount: String = "") {
        self.unitIndex = unitIndex
        self.enteredAmount = enteredAmount
    }
}
