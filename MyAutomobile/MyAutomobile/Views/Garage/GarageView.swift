//
//  GarageView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct GarageView: View {
    
    @Environment(\.editMode) private var editMode
    @StateObject private var viewModel: GarageViewModel
    @State private var showAddView = false
    
    init(viewModel: GarageViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Vehicles")
                .navigationDestination(for: Vehicle.self) { vehicle in
                    VehicleDetailsView(viewModel: .init(vehicle: vehicle))
                }
                .garageToolbar(hasVehicles: viewModel.hasVehicles) {
                    showAddView.toggle()
                }
                .sheet(isPresented: $showAddView) {
                    Text("Add View")
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.hasVehicles {
            List {
                ForEach(viewModel.vehicles) { vehicle in
                    NavigationLink(value: vehicle) {
                        VehicleRowView(vehicle: vehicle)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
        } else {
            Text("You haven't added any vehicles.")
                .font(.body)
                .multilineTextAlignment(.center)
        }
    }
    
}

// MARK: - Previews

struct GarageView_Previews: PreviewProvider {
    static var previews: some View {
        GarageView(viewModel: .init(vehicles: .demoVehicles))
        
        GarageView(viewModel: .init(vehicles: []))
            .preferredColorScheme(.dark)
    }
}
