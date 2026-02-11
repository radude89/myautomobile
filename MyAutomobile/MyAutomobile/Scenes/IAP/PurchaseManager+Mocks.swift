//
//  PurchaseManager+UITests.swift
//  MyAutomobile
//
//  Created by Radu Dan on 07.07.2025.
//

import Foundation
import UITestEnvironment

extension PurchaseManager {
    func setupMockEnvironmentIfNeeded() {
        if ProcessInfo.processInfo.environment[UITestEnvironment.Key.testing] == "true" {
            userDefaults.set(999, forKey: storageKey)
            purchasedNonConsumableProductIDs.insert(Self.productIDs[1])
        }
    }
}
