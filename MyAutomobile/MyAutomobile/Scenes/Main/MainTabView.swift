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
        tabView
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                saveData()
            }
    }
}

// MARK: - Private methods

private extension MainTabView {
    var tabView: some View {
        TabView {
            VehicleListView(
                viewModel: .init(
                    vehicles: vehicles,
                    eventStoreManager: storeManager,
                    purchaseManager: purchaseManager
                )
            )
            .tabItem { Label("Vehicles", systemImage: "car.2.fill") }
            .tag(1)
            .environmentObject(purchaseManager)
            .task {
                await purchaseManager.updatePurchasedProducts()
            }
            
            EventListView(
                viewModel: .init(vehicles: vehicles, eventStoreManager: storeManager)
            )
            .tabItem { Label("Events", systemImage: "calendar")}
            .tag(2)
            
            ParkLocationView()
                .tabItem { Label("Parking", systemImage: "parkingsign") }
                .tag(3)
            
            MoreView(
                viewModel: .init(vehicles: vehicles)
            )
            .tabItem { Label("More", systemImage: "gear") }
            .tag(4)
        }
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(vehicles.items)
            try FileManager.write(data: data, fileName: Vehicles.storageKey)
        } catch {
            print("Unable to save data, error: \(error.localizedDescription)")
        }
    }
}
