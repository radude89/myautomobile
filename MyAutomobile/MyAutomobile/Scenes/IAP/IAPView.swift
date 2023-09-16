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
    private let titles: [String] = ["1x", "3x", "5x", "∞ x"]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("iap.title")
                .padding([.leading, .trailing, .bottom])
            
            VStack(spacing: 20) {
                ForEach(Array(purchaseManager.products.enumerated()), id: \.element.id) { index, product in
                    IAPButton(title: titles[index], subtitle: product.displayName) {
                        Task { await buyProduct(product) }
                    }
                    .disabled(purchaseManager.hasPurchasedProduct(withID: product.id))
                }
                restoreButton
                
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .task { await loadProducts() }
    }
}

// MARK: - Private

private extension IAPView {
    var restoreButton: some View {
        Button(action: {}, label: {
            Text("Restore purchases")
                .bold()
        })
        .padding()
        .foregroundStyle(.pink)
        .backgroundStyle(.pink)
        .overlay(
            RoundedRectangle(cornerRadius: 6.0)
                .stroke(.pink, lineWidth: 1.0)
        )
    }

    func loadProducts() async {
        do {
            _ = purchaseManager.availableVehicleSlots
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
}

// MARK: - Preview

#Preview {
    IAPView()
}
