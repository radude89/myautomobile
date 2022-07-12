//
//  GarageView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct GarageView: View {
    
    @StateObject private var viewModel: GarageViewModel
    @State private var editMode: EditMode
    
    init(
        viewModel: GarageViewModel = .init(),
        editMode: EditMode = .inactive
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _editMode = State(initialValue: editMode)
    }
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Vehicles")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !viewModel.hasVehicles {
                            EditButton()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Add...")
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .environment(\.editMode, $editMode)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.hasVehicles {
            Text("You haven't added any vehicles.")
                .font(.body)
                .multilineTextAlignment(.center)
        } else {
            List(viewModel.vehicles) { VehicleRowView(vehicle: $0) }
        }
    }
    
}

// MARK: - Previews

struct GarageView_Previews: PreviewProvider {
    static var previews: some View {
        GarageView(viewModel: .init(vehicles: .demoVehicles))

        GarageView()
            .preferredColorScheme(.dark)
    }
}
