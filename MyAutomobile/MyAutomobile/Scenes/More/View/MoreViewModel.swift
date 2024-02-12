//
//  MoreViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

final class MoreViewModel: ObservableObject {
    @ObservedObject var vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
    
    func title(for item: MoreItem) -> String {
        switch item {
        case .expenses:
            return "Expense tracking"
        case .maintenance:
            return "Maintenance"
        }
    }
    
    func emptyViewTitle(for item: MoreItem) -> String {
        switch item {
        case .expenses:
            return "expenses_empty"
        case .maintenance:
            return "maintenance_empty"
        }
    }
}
