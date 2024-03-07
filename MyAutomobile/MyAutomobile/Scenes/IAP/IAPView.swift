//
//  IAPView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.09.2023.
//

import SwiftUI
import StoreKit

struct IAPView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @State private var showInfoAlert = false

    private let titles: [String] = ["1x", "∞ x"]
    
    let availableSlots: Int
    let numberOfAddedVehicles: Int
    let showCancelButton: Bool
    let hasBoughtUnlimitedVehicles: Bool
    
    init(availableSlots: Int,
         numberOfAddedVehicles: Int,
         hasBoughtUnlimitedVehicles: Bool,
         showCancelButton: Bool = true) {
        self.availableSlots = availableSlots
        self.numberOfAddedVehicles = numberOfAddedVehicles
        self.hasBoughtUnlimitedVehicles = hasBoughtUnlimitedVehicles
        self.showCancelButton = showCancelButton
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Vehicle Packs")
                .toolbar {
                    if showCancelButton {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Cancel") { dismiss() }
                        }
                    }
                }
        }
    }
}

// MARK: - Private

private extension IAPView {
    @ViewBuilder
    var contentView: some View {
        if hasBoughtUnlimitedVehicles {
            Text("iap.infinite")
                .multilineTextAlignment(.center)
                .font(.title3)
                .bold()
        } else {
            productsView
                .alert("Warning", isPresented: $showInfoAlert) {
                    Button("OK", role: .cancel) {
                        showInfoAlert = false
                    }
                } message: {
                    Text("Something went wrong")
                }
        }
    }
    
    var productsView: some View {
        VStack {
            VStack(spacing: 32) {
                Text(currentPackDescription)
                    .font(.title3)
                    .bold()
                Text("iap.title")
            }
            .padding(12)
            
            VStack(spacing: 16) {
                StoreView(ids: PurchaseManager.productIDs)
                    .productViewStyle(.compact)
                    .storeButton(.visible, for: .restorePurchases)
                    .storeButton(.hidden, for: .cancellation)
                    .onInAppPurchaseCompletion { _, result in
                        handleAppStoreCompletion(result: result)
                    }
                    .padding([.leading, .trailing], 12)
            }
            .padding()
        }
    }
    
    var currentPackDescription: String {
        String(
            format: NSLocalizedString("You own vehicles", comment: ""),
            numberOfAddedVehicles,
            availableSlots
        )
    }
    
    func handleAppStoreCompletion(
        result: Result<Product.PurchaseResult, any Error>
    ) {
        switch result {
        case let .success(purchaseResult):
            handlePurchaseResult(purchaseResult)
        case let .failure(error):
            print(error)
            showInfoAlert = true
        }
    }
    
    func handlePurchaseResult(_ result: Product.PurchaseResult) {
        switch result {
        case let .success(transactionResult):
            purchaseManager.handle(transactionResult: transactionResult)
        default:
            break
        }
    }
}
