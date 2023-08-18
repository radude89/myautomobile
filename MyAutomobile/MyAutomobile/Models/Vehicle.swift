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
    struct FieldDetails {
        let dateCreated: Date
        let key: String
        let value: String
    }
}

extension Vehicle: Equatable, Identifiable, Hashable {}

extension Vehicle.FieldDetails: Equatable, Hashable, Comparable {
    static func < (lhs: Vehicle.FieldDetails, rhs: Vehicle.FieldDetails) -> Bool {
        lhs.dateCreated < rhs.dateCreated
    }
}
