//
//  Vehicle.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import Foundation

struct Vehicle {
    let id = UUID()
    let make: String
    let model: String
    let numberPlate: String
    let photoData: Data?
}

extension Vehicle: Identifiable {}
