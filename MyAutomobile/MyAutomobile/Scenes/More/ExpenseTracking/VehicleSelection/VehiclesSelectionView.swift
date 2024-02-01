//
//  VehiclesSelectionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

struct VehiclesSelectionView<Destination: View>: View {
    @StateObject private var viewModel: VehiclesSelectionViewModel
    private let destinationViewProvider: (Vehicle) -> Destination

    init(
        viewModel: VehiclesSelectionViewModel,
        @ViewBuilder destinationViewProvider: @escaping (Vehicle) -> Destination
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.destinationViewProvider = destinationViewProvider
    }

    var body: some View {
        List(viewModel.vehicles.items) { vehicle in
            NavigationLink(vehicle.numberPlate) {
                destinationViewProvider(vehicle)
            }
        }
    }
}
