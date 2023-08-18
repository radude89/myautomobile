//
//  Vehicle.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct Vehicle {
    let id = UUID()
    var make: String
    var model: String
    var numberPlate: String
    var color: Color
    var customFields: [String: FieldDetails] = [:]
}

extension Vehicle {
    struct FieldDetails: Equatable, Hashable {
        let key: String
        let value: String
    }
}

extension Vehicle: Identifiable {}

extension Vehicle: Hashable {}
