//
//  PurchaseManager+UITests.swift
//  MyAutomobile
//
//  Created by Radu Dan on 07.07.2025.
//

import Foundation

extension PurchaseManager {
    func setupMockEnvironmentIfNeeded() {
        if ProcessInfo.processInfo.environment["UITesting"] == "true" {
            userDefaults.set(999, forKey: storageKey)
            purchasedNonConsumableProductIDs.insert(Self.productIDs[1])
        }
    }
}
