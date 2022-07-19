//
//  Vehicle.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import Foundation

struct Vehicle {
    let id = UUID()
    var make: String
    var model: String
    var numberPlate: String
    var photoData: Data?
}

extension Vehicle: Identifiable {}

extension Vehicle: Hashable {}
