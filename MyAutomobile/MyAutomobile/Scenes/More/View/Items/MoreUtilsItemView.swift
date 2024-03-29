//
//  MoreUtilsItemView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.02.2024.
//

import SwiftUI

struct MoreUtilsItemView<DetailsView: View>: View {
    @StateObject private var viewModel: MoreUtilsItemViewModel
    private let detailsView: (Vehicle) -> DetailsView
    
    init(viewModel: MoreUtilsItemViewModel,
         detailsView: @escaping (Vehicle) -> DetailsView) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.detailsView = detailsView
    }
    
    var body: some View {
        NavigationLink {
            contentView
                .navigationTitle("Vehicles")
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            Label(viewModel.title, systemImage: viewModel.imageName)
        }
        
    }
}

// MARK: - Private
private extension MoreUtilsItemView {
    var contentView: some View {
        guard !viewModel.items.isEmpty,
              let firstVehicle = viewModel.firstVehicle else {
            return AnyView(emptyView)
        }
        
        return if viewModel.hasMoreThanOneVehicle {
            AnyView(selectionView)
        } else {
            AnyView(
                detailsView(firstVehicle)
            )
        }
    }
    
    var emptyView: some View {
        Text(String(localized: viewModel.emptyViewTitle))
            .font(.body)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing], 32)
    }
    
    var selectionView: some View {
        Form {
            Section {
                VehiclesSelectionView(
                    viewModel: .init(vehicles: viewModel.vehicles)
                ) { vehicle in
                    detailsView(vehicle)
                }
            } header: {
                Text("Select vehicle")
            }
        }
    }
}
