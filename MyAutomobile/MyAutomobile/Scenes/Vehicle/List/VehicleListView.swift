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
    
    init(viewModel: VehicleListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Vehicles")
                .navigationDestination(for: Vehicle.self) { vehicle in
                    VehicleDetailsView(viewModel: .init(vehicle: vehicle, vehicles: viewModel.vehicles))
                }
                .vehicleListToolbar(hasVehicles: viewModel.hasVehicles) {
                    showAddView.toggle()
                }
                .sheet(isPresented: $showAddView) {
                    VehicleAddView(viewModel: .init(vehicles: viewModel.vehicles))
                }
                .onReceive(viewModel.vehicles.objectWillChange) {
                    viewModel.objectWillChange.send()
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
                    Task {
                        await viewModel.delete(atOffsets: indexSet)
                    }
                }
            }
        } else {
            Text("You haven't added any vehicles.")
                .font(.body)
                .multilineTextAlignment(.center)
        }
    }
    
}
