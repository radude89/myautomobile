//
//  ExpensesLoader.swift
//  MyAutomobile
//
//  Created by Radu Dan on 09.02.2026.
//

import XCTest
import Foundation

enum ExpensesLoader: DataLoader {
    static func load(supportedLocale: SupportedLocale = .english) -> [ExpenseTestData] {
        guard let expensesJSON: ModelJSON<ExpenseData> = loadJSON(resource: "expenses"),
              let vehiclesJSON: ModelJSON<VehicleData> = loadJSON(resource: "vehicles") else {
            return []
        }
        
        let expenses = expensesJSON[keyPath: supportedLocale.objectsKeyPath()]
        let vehicles = vehiclesJSON[keyPath: supportedLocale.objectsKeyPath()]
        return expenses.map { expense in
            ExpenseTestData(expenseData: expense, vehicles: vehicles)
        }
    }
}

private extension ExpenseTestData {
    init(expenseData: ExpenseData, vehicles: [VehicleData]) {
        title = expenseData.title
        type = ExpenseType(rawValue: expenseData.type) ?? .other

        if let vehicle = vehicles.first(where: { vehicle in
            vehicle.id == expenseData.vehicleId
        }) {
            vehiclePlate = vehicle.plate
        } else {
            vehiclePlate = ""
        }
        
        occurrence = switch expenseData.date {
        case "yesterday": .yesterday
        case "one week ago": .oneWeekAgo
        case "two weeks ago": .twoWeeksAgo
        case "three weeks ago": .threeWeeksAgo
        case "one month ago": .oneMonthAgo
        default: .today
        }
        
        cost = expenseData.cost
        comment = expenseData.comment
        odometer = expenseData.odometer
    }
}
