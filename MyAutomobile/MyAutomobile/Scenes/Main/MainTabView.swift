//
//  MainTabView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 04.04.2022.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var vehicles = Vehicles()
    @StateObject private var storeManager = EventStoreManager()
    @StateObject private var purchaseManager = PurchaseManager()

    var body: some View {
        TabView {
            VehicleListView(viewModel: .init(vehicles: vehicles, eventStoreManager: storeManager, purchaseManager: purchaseManager))
                .tabItem {
                    Label("Vehicles", systemImage: "car.2.fill")
                }
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
            
            EventListView(viewModel: .init(vehicles: vehicles, eventStoreManager: storeManager))
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            saveData()
        }
    }
}

private extension MainTabView {
    func saveData() {
        do {
            let data = try JSONEncoder().encode(vehicles.items)
            try FileManager.write(data: data, fileName: Vehicles.storageKey)
        } catch {
            print("Unable to save data, error: \(error.localizedDescription)")
        }
    }
}
