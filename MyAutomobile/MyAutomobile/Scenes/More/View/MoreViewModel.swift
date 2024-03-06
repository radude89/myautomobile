//
//  MoreViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

final class MoreViewModel: ObservableObject {
    @ObservedObject var vehicles: Vehicles
    private static let appName = "CarChum"
    private let purchaseManager: PurchaseManager
    
    init(vehicles: Vehicles, purchaseManager: PurchaseManager) {
        self.vehicles = vehicles
        self.purchaseManager = purchaseManager
    }
    
    var footnote: String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {
            return Self.appName
        }
        
        guard let build = dictionary["CFBundleVersion"] as? String else {
            return "\(Self.appName) v\(version)"
        }
        
        return "\(Self.appName) v\(version) (\(build))"
    }
    
    var emailSubject: String {
        String(
            format: NSLocalizedString("Hello from", comment: "Subject"), footnote
        )
    }
    
    var numberOfAddedVehicles: Int {
        vehicles.items.count
    }
    
    var availableSlots: Int {
        purchaseManager.purchasedVehicleSlots
    }
    
    func title(for item: MoreItem) -> String {
        return switch item {
        case .expenses:
            String(localized: .init("Expense tracking"))
        case .maintenance:
            String(localized: .init("Maintenance"))
        }
    }
    
    func emptyViewTitle(for item: MoreItem) -> String.LocalizationValue {
        return switch item {
        case .expenses:
            "expenses_empty"
        case .maintenance:
            "maintenance_empty"
        }
    }
}
