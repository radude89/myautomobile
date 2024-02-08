//
//  ExpenseRowViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 06.02.2024.
//

import SwiftUI

struct ExpenseRowViewModel {
    private let expense: Expense
    private let odometerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    var leadingTitle: String {
        expense.expenseType.name
    }
    
    var expenseDate: Date {
        expense.date
    }
    
    var coment: String? {
        expense.comment
    }
    
    var trailingTitle: String {
        NumberFormatterFactory
            .makeAmountFormatter()
            .string(from: NSNumber(value: expense.cost)) ?? "-"
    }
    
    var odometerReading: String? {
        guard let odometerReading = expense.odometerReading,
              let reading = odometerFormatter.string(from: NSNumber(value: odometerReading)) else {
            return nil
        }
        
        return "Odometer: \(reading)"
    }
    
    var imageName: String {
        expense.expenseType.imageName
    }
    
    var color: Color {
        expense.expenseType.color
    }
}
