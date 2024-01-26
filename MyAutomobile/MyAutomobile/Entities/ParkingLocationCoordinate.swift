//
//  ParkingLocationCoordinate.swift
//  MyAutomobile
//
//  Created by Radu Dan on 26.01.2024.
//

import Foundation

struct ParkingLocationCoordinate {
    let id: UUID
    let latitude: Double
    let longitude: Double
    
    init(id: UUID = .init(), latitude: Double, longitude: Double) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension ParkingLocationCoordinate: Identifiable {}

extension ParkingLocationCoordinate: Codable {}
