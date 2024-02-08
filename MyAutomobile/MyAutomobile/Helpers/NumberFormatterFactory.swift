//
//  NumberFormatterFactory.swift
//  MyAutomobile
//
//  Created by Radu Dan on 08.02.2024.
//

import Foundation

enum NumberFormatterFactory {
    static func makeAmountFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "💰"
        return formatter
    }
}
