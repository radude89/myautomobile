//
//  MainTabView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 04.04.2022.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var vehicles = Vehicles()

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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            saveData()
        }
    }
}

private extension MainTabView {
    func saveData() {
        do {
            let uri = FileManager.documentsDirectoryURL.appendingPathComponent(Vehicles.storageKey)
            let data = try JSONEncoder().encode(vehicles.items)
            try data.write(to: uri, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to load data, error: \(error.localizedDescription)")
        }
    }
}
