//
//  VehicleDetailsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.07.2022.
//

import SwiftUI

struct VehicleDetailsView: View {
    
    @Environment(\.editMode) private var editMode
    
    @StateObject private var viewModel: VehicleDetailsViewModel

    @State private var makeText = ""
    @State private var modelText = ""
    @State private var numberPlateText = ""
    @State private var vehicleColor = Color.clear
    
    init(viewModel: VehicleDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            VehicleDetailsTopSection(
                vehicleColor: vehicleColor,
                numberPlateText: $numberPlateText
            )
            VehicleDetailsMandatoryFieldsSection(
                makeText: $makeText,
                modelText: $modelText,
                vehicleColor: $vehicleColor
            )
            VehicleDetailsCustomFieldsSection(
                customFields: viewModel.customFields,
                onSave: saveDetails,
                onDelete: viewModel.deleteFields
            )
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Details")
        .onAppear(perform: loadVehicleDetails)
        .onDisappear(perform: updateVehicle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
}

// MARK: - Private methods
private extension VehicleDetailsView {
    func loadVehicleDetails() {
        makeText = viewModel.vehicleMake
        modelText = viewModel.vehicleModel
        numberPlateText = viewModel.vehicleNumberPlate
        vehicleColor = viewModel.vehicleColor
    }
    
    func saveDetails(key: String, value: String) {
        guard !key.isEmpty && !value.isEmpty else {
            return
        }
        
        viewModel.updateCustomField(
            labelText: key,
            valueText: value
        )
    }
    
    func updateVehicle() {
        viewModel.updateVehicle()
    }
}
