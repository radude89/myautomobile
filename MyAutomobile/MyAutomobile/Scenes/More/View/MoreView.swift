//
//  MoreView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

@MainActor
struct MoreView: View {
    @StateObject private var viewModel: MoreViewModel
    
    init(viewModel: MoreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("More")
        }
    }
}

// MARK: - Private
private extension MoreView {
    var contentView: some View {
        Form {
            utilsSection
        }
    }

    var utilsSection: some View {
        Section {
            makeItemView(for: .expenses, imageName: "pencil.line")
            makeItemView(for: .maintenance, imageName: "screwdriver.fill")
            FuelConsumptionView()
        } header: {
            Text("Utils")
        }
    }
    
    func makeItemView(for item: MoreItem, imageName: String) -> some View {
        MoreUtilsItemView(
            viewModel: .init(
                vehicles: viewModel.vehicles,
                title: viewModel.title(for: item),
                imageName: imageName,
                emptyViewTitle: viewModel.emptyViewTitle(for: item)
            )
        ) { vehicle in
            makeDetailsView(for: item, vehicleID: vehicle.id)
        }
    }
    
    @ViewBuilder 
    func makeDetailsView(
        for item: MoreItem,
        vehicleID: UUID
    ) -> some View {
        switch item {
        case .expenses:
            ExpenseTrackingView(
                viewModel: .init(
                    vehicles: viewModel.vehicles,
                    vehicleID: vehicleID
                )
            )
        case .maintenance:
            ExpenseTrackingView(
                viewModel: .init(
                    vehicles: viewModel.vehicles,
                    vehicleID: vehicleID,
                    showOnlyMaintenanceItems: true
                )
            )
        }
    }
}