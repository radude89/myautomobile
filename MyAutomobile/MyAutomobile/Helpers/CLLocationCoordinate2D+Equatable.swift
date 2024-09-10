//
//  CLLocationCoordinate2D+Equatable.swift
//  MyAutomobile
//
//  Created by Radu Dan on 26.01.2024.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && rhs.latitude == rhs.longitude
    }
}
