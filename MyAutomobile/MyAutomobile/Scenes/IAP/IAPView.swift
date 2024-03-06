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
                .task { await loadProducts() }
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
            
            VStack(spacing: 20) {
                ForEach(Array(purchaseManager.products.enumerated()), id: \.element.id) { index, product in
                    IAPButton(title: titles[index], subtitle: subtitle(for: product)) {
                        Task { await buyProduct(product) }
                    }
                }
                restoreButton
            }
            .fixedSize(horizontal: true, vertical: false)
            
            Spacer()
        }
    }
    
    var currentPackDescription: String {
        return String(
            format: NSLocalizedString("You own vehicles", comment: ""),
            numberOfAddedVehicles,
            availableSlots
        )
    }

    var restoreButton: some View {
        Button(action: {
            Task {
                do {
                    try await AppStore.sync()
                } catch {
                    print(error)
                }
            }
        }, label: {
            Text("Restore purchases")
                .bold()
        })
        .padding()
        .foregroundStyle(Color("app_color"))
        .backgroundStyle(Color("app_color"))
        .overlay(
            RoundedRectangle(cornerRadius: 6.0)
                .stroke(Color("app_color"), lineWidth: 1.0)
        )
    }

    func loadProducts() async {
        do {
            try await purchaseManager.loadProducts()
        } catch {
            print(error)
        }
    }
    
    func buyProduct(_ product: Product) async {
        do {
            try await purchaseManager.purchase(product)
        } catch {
            print(error)
        }
    }
    
    func subtitle(for product: Product) -> String {
        "\(product.displayName) - \(product.displayPrice)"
    }
}
