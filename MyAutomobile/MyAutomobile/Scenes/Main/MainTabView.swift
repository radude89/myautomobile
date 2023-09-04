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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
