//
//  ExpenseRowViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 06.02.2024.
//

import SwiftUI

struct ExpenseRowViewModel {
    private let expense: Expense
    
    private let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }()
    
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
        amountFormatter.string(from: NSNumber(value: expense.cost)) ?? "-"
    }
    
    var odometerReading: String? {
        guard let odometerReading = expense.odometerReading,
              let reading = odometerFormatter.string(from: NSNumber(value: odometerReading)) else {
            return nil
        }
        
        return "Odometer: \(reading)"
    }
    
    var imageName: String {
        switch expense.expenseType {
        case .insurance:
            "paperclip.circle.fill"
        case .repair:
            "hammer.circle.fill"
        case .maintenance:
            "timer"
        case .fuel:
            "fuelpump.circle.fill"
        case .toll:
            "sailboat.circle.fill"
        case .parking:
            "parkingsign.circle.fill"
        case .other:
            "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch expense.expenseType {
        case .insurance:
            .mint
        case .repair:
            .pink
        case .maintenance:
            .mint
        case .fuel:
            .orange
        case .toll:
            .teal
        case .parking:
            .cyan
        case .other:
            .indigo
        }
    }
}
