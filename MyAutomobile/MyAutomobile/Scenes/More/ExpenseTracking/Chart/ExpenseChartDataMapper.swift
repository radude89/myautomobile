//
//  ExpenseChartDataMapper.swift
//  MyAutomobile
//
//  Created by Radu Dan on 08.02.2024.
//

import Foundation

enum ExpenseChartDataMapper {
    static func map(expenses: [Expense]) -> [ExpenseData] {
        expenses.reduce(into: []) { result, expense in
            if let index = result.firstIndex(where: { $0.expenseType == expense.expenseType }) {
                result[index].cost += expense.cost
            } else {
                result.append(ExpenseData(expenseType: expense.expenseType, cost: expense.cost))
            }
        }
    }
}
