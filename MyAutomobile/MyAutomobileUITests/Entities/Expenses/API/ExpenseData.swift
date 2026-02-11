//
//  ExpenseData.swift
//  MyAutomobile
//
//  Created by Radu Dan on 09.02.2026.
//

import Foundation

struct ExpenseData: Decodable {
    let title: String
    let type: String
    let vehicleId: Int
    let date: String
    let cost: Double
    let comment: String?
    let odometer: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case vehicleId = "vehicle_id"
        case date
        case cost
        case comment
        case odometer
    }
}
