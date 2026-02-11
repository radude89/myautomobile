//
//  ExpenseTestData.swift
//  MyAutomobile
//
//  Created by Radu Dan on 09.02.2026.
//

import Foundation

struct ExpenseTestData {
    let title: String
    let type: ExpenseType
    let vehiclePlate: String
    let occurrence: ExpenseTestData.Occurence
    let cost: Double
    let comment: String?
    let odometer: Int?
}

extension ExpenseTestData {
    enum Occurence {
        case yesterday
        case today
        case oneWeekAgo
        case twoWeeksAgo
        case threeWeeksAgo
        case oneMonthAgo
    }
}

enum ExpenseType: String {
    case insurance
    case parking
    case maintenance
    case toll
    case repair
    case other
}
