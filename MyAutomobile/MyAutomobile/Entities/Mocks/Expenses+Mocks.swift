//
//  Expenses+Mocks.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.02.2026.
//

import Foundation
import UITestEnvironment

extension Expense {
    static func loadMockData() -> [Expense] {
        guard let expenseDataString = ProcessInfo.processInfo.environment[UITestEnvironment.Key.expenses] else {
            return []
        }
        guard let data = expenseDataString.data(using: .utf8),
              let expenseDataArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            print("Failed to load mock expense data")
            return []
        }
        
        return expenseDataArray.compactMap { expenseData in
            guard let type = expenseData["type"] as? String,
                  let dateLabel = expenseData["date"] as? String,
                  let cost = expenseData["cost"] as? Double else {
                return nil
            }
            
            let comment = expenseData["comment"] as? String
            let odometer = expenseData["odometer"] as? Int
            let expenseType: ExpenseType = .init(rawValue: type) ?? .other
            
            let date = switch dateLabel {
            case "yesterday": Date.days(-1)
            case "one week ago": Date.days(-7)
            case "two weeks ago": Date.days(-14)
            case "three weeks ago": Date.days(-21)
            case "one month ago": Date.months(-1)
            default: Date.now
            }
            
            return Expense(
                date: date,
                odometerReading: odometer,
                expenseType: expenseType,
                cost: cost,
                comment: comment
            )
        }
    }
}

private extension Date {
    static func days(_ numberOfDays: Int) -> Self {
        Calendar.autoupdatingCurrent
            .date(byAdding: .day, value: numberOfDays, to: .now) ?? .now
    }
    
    static func months(_ numberOfMonths: Int) -> Self {
        Calendar.autoupdatingCurrent
            .date(byAdding: .month, value: numberOfMonths, to: .now) ?? .now
    }
}
