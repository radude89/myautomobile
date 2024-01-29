//
//  VehiclesSelectionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

struct VehiclesSelectionView<Destination: View>: View {
    private let vehicles: Vehicles
    private let destinationViewProvider: (Vehicle) -> Destination

    init(
        vehicles: Vehicles,
        @ViewBuilder destinationViewProvider: @escaping (Vehicle) -> Destination
    ) {
        self.vehicles = vehicles
        self.destinationViewProvider = destinationViewProvider
    }

    var body: some View {
        List(vehicles.items) { vehicle in
            NavigationLink(vehicle.numberPlate) {
                destinationViewProvider(vehicle)
            }
        }
    }
}
