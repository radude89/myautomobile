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
    private let titles: [String] = ["1x", "∞ x"]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("iap.title")
                .padding([.leading, .trailing, .bottom])
            
            VStack(spacing: 20) {
                ForEach(Array(purchaseManager.products.enumerated()), id: \.element.id) { index, product in
                    IAPButton(title: titles[index], subtitle: subtitle(for: product)) {
                        Task { await buyProduct(product) }
                    }
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

// MARK: - Preview

#Preview {
    IAPView()
}
