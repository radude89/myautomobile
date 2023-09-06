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

    var body: some View {
        TabView {
            GarageView(viewModel: .init(vehicles: vehicles))
                .tabItem {
                    Label("Garage", systemImage: "car.2.fill")
                }
            
            EventsView(viewModel: .init(vehicles: vehicles))
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
        }
        .environmentObject(storeManager)
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
