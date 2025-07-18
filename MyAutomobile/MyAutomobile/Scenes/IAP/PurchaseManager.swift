//
//  PurchaseManager.swift
//  MyAutomobile
//
//  Created by Radu Dan on 16.09.2023.
//

import Foundation
import StoreKit

final class PurchaseManager: ObservableObject, @unchecked Sendable {
    private(set) var storageKey = "vehicle-slots"
    private(set) var userDefaults = UserDefaults.standard
    private var updates: Task<Void, Never>? = nil
    
    @Published private(set) var purchasedVehicleSlots = 0
    @Published var purchasedNonConsumableProductIDs = Set<String>()
    
    static let productIDs = [
        "com.rdan.myautomobile.iap.onec",
        "com.rdan.myautomobile.iap.infinitec",
    ]
    
    init() {
        setupMockEnvironmentIfNeeded()
        loadSlots()
        updates = observeTransactionUpdates()
    }
    
    var hasBoughtUnlimitedVehicles: Bool {
        purchasedNonConsumableProductIDs.contains(Self.productIDs[1])
    }

    @MainActor
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            handle(transactionResult: result)
        }
    }
    
    func handle(transactionResult: VerificationResult<Transaction>) {
        guard case .verified(let transaction) = transactionResult else {
            return
        }

        if transaction.productType == .consumable {
            handlePurchasedConsumable(transaction: transaction)
        } else {
            handlePurchasedNonConsumable(transaction: transaction)
        }
    }
}

// MARK: - Storage

private extension PurchaseManager {
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            for await result in Transaction.updates {
                self.handle(transactionResult: result)
            }
        }
    }

    func loadSlots() {
        let slots = userDefaults.integer(forKey: storageKey)
        if slots == 0 {
            increaseVehicleStorageSlot()
        }
        updatePurchasedVehicleSlots()
    }
    
    func handlePurchasedConsumable(transaction: Transaction) {
        guard transaction.productID == Self.productIDs[0] else {
            return
        }
        
        Task { @MainActor in
            purchasedVehicleSlots += 1
        }
        increaseVehicleStorageSlot()
    }
    
    func handlePurchasedNonConsumable(transaction: Transaction) {
        if transaction.revocationDate == nil {
            purchasedNonConsumableProductIDs.insert(transaction.productID)
        } else {
            purchasedNonConsumableProductIDs.remove(transaction.productID)
        }
    }
    
    func increaseVehicleStorageSlot() {
        let availableSlots = userDefaults.integer(forKey: storageKey)
        userDefaults.set(availableSlots + 1, forKey: storageKey)
    }
    
    func updatePurchasedVehicleSlots() {
        purchasedVehicleSlots = userDefaults.integer(forKey: storageKey)
    }
}
