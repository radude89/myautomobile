//
//  VehicleListView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct VehicleListView: View {

    @Environment(\.editMode) private var editMode
    @StateObject private var viewModel: VehicleListViewModel
    @State private var showAddView = false
    @State private var isEditing = false
    
    init(viewModel: VehicleListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Vehicles")
                .navigationDestination(for: Vehicle.self) { vehicle in
                    VehicleDetailsView(
                        viewModel: .init(
                            vehicle: vehicle,
                            vehicles: viewModel.vehicles
                        )
                    )
                }
                .vehicleListToolbar(
                    hasVehicles: viewModel.hasVehicles,
                    isEditing: $isEditing
                ) {
                    showAddView.toggle()
                }
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .sheet(isPresented: $showAddView) {
                    if viewModel.canPresentAddView {
                        VehicleAddView(
                            viewModel: .init(vehicles: viewModel.vehicles)
                        )
                    } else {
                        IAPView(
                            availableSlots: viewModel.availableSlots,
                            numberOfAddedVehicles: viewModel.numberOfAddedVehicles,
                            hasBoughtUnlimitedVehicles: viewModel.hasBoughtUnlimitedVehicles
                        )
                    }
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.hasVehicles {
            List {
                ForEach(viewModel.vehicles.items) { vehicle in
                    NavigationLink(value: vehicle) {
                        VehicleListRowView(vehicle: vehicle)
                    }
                }
                .onDelete { indexSet in
                    viewModel.delete(atOffsets: indexSet)
                    Task { @MainActor in
                        if !viewModel.hasVehicles {
                            isEditing = false
                        }
                    }
                }
            }
        } else {
            Text("vehicles_empty")
                .font(.body)
                .multilineTextAlignment(.center)
        }
    }
    
}
