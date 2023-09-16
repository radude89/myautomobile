//
//  PurchaseManager.swift
//  MyAutomobile
//
//  Created by Radu Dan on 16.09.2023.
//

import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    private let productIDs = [
        "com.rdan.myautomobile.iap.onevehicle",
        "com.rdan.myautomobile.iap.threevehicles",
        "com.rdan.myautomobile.iap.fivevehicles",
        "com.rdan.myautomobile.iap.unlimitedvehicles",
    ]
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    var hasBoughtUnlimitedVehicles: Bool {
        hasPurchasedProduct(withID: products.last?.id)
    }
    
    var availableVehicleSlots: Int {
        print("Purchased product IDs: \(purchasedProductIDs).")
        var slots = 1
        if hasPurchasedProduct(withID: products.first?.id) {
            slots += 1
        }
        if hasPurchasedProduct(withID: products[safe: 1]?.id) {
            slots += 3
        }
        if hasPurchasedProduct(withID: products[safe: 2]?.id) {
            slots += 5
        }
        print("Number of vehicle slots: \(slots).")
        return slots
    }
    
    func loadProducts() async throws {
        guard !productsLoaded else { return }
        products = try await Product.products(for: productIDs).sorted { $0.price < $1.price }
        productsLoaded = true
        print(products)
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        print(result)
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await updatePurchasedProducts()
        default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            handleTransactionResult(result)
        }
    }
    
    func hasPurchasedProduct(withID id: String?) -> Bool {
        guard let id else {
            return false
        }

        return purchasedProductIDs.contains(id)
    }
}

// MARK: - Private

private extension PurchaseManager {
    func handleTransactionResult(_ result: VerificationResult<Transaction>) {
        guard case .verified(let transaction) = result else {
            return
        }

        if transaction.revocationDate == nil {
            purchasedProductIDs.insert(transaction.productID)
        } else {
            purchasedProductIDs.remove(transaction.productID)
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

private extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
