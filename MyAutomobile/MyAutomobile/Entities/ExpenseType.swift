//
//  ExpenseType.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

enum ExpenseType: String, CaseIterable {
    case insurance
    case repair
    case maintenance
    case fuel
    case toll
    case parking
    case other
}

extension ExpenseType: Codable {}

extension ExpenseType {
    var name: String {
        rawValue.capitalized
    }
    
    var imageName: String {
        switch self {
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
        switch self {
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
