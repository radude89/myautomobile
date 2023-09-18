//
//  PurchaseManager.swift
//  MyAutomobile
//
//  Created by Radu Dan on 16.09.2023.
//

import Foundation
import StoreKit

@MainActor
final class PurchaseManager: NSObject, ObservableObject {
    private let productIDs = [
        "com.rdan.myautomobile.iap.onec",
        "com.rdan.myautomobile.iap.infinitec",
    ]
    private let storageKey = "vehicle-slots"
    private let userDefaults = UserDefaults.standard
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedNonConsumableProductIDs = Set<String>()
    @Published private(set) var purchasedVehicleSlots = 0
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    override init() {
        super.init()
        updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
        loadSlots()
    }
    
    deinit {
        updates?.cancel()
    }
    
    var hasBoughtUnlimitedVehicles: Bool {
        purchasedNonConsumableProductIDs.contains(productIDs[1])
    }
    
    func loadProducts() async throws {
        guard !productsLoaded else { return }
        products = try await Product.products(for: productIDs).sorted { $0.price < $1.price }
        productsLoaded = true
        print(products)
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            handleTransactionResult(result)
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        print(result)
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            handlePurchasedProduct(transaction: transaction)
        default:
            break
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}

// MARK: - Transactions

private extension PurchaseManager {
    func handleTransactionResult(_ result: VerificationResult<Transaction>) {
        guard case .verified(let transaction) = result else {
            return
        }
        
        handlePurchasedProduct(transaction: transaction)
    }
    
    func handlePurchasedProduct(transaction: Transaction) {
        if transaction.productType == .consumable {
            handlePurchasedConsumable(transaction: transaction)
        } else {
            handlePurchasedNonConsumable(transaction: transaction)
        }
    }
    
    func handlePurchasedConsumable(transaction: Transaction) {
        guard transaction.productID == productIDs[0] else {
            return
        }

        purchasedVehicleSlots += 1
        increaseVehicleStorageSlot()
    }
    
    func handlePurchasedNonConsumable(transaction: Transaction) {
        if transaction.revocationDate == nil {
            purchasedNonConsumableProductIDs.insert(transaction.productID)
        } else {
            purchasedNonConsumableProductIDs.remove(transaction.productID)
        }
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                self?.handleTransactionResult(result)
            }
        }
    }
}

// MARK: - Storage

private extension PurchaseManager {
    func loadSlots() {
        let slots = userDefaults.integer(forKey: storageKey)
        if slots == 0 {
            increaseVehicleStorageSlot()
        }
        updatePurchasedVehicleSlots()
    }
    
    func updatePurchasedVehicleSlots() {
        purchasedVehicleSlots = userDefaults.integer(forKey: storageKey)
    }
    
    func increaseVehicleStorageSlot() {
        let availableSlots = userDefaults.integer(forKey: storageKey)
        userDefaults.set(availableSlots + 1, forKey: storageKey)
    }
}

// MARK: - Collection extension

private extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
