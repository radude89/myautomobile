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
        contentView
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Details")
            .onAppear(perform: loadVehicleDetails)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                        .disabled(viewModel.customFields.isEmpty)
                }
            }
            .onChange(of: modelText) { set(\.model, newValue: $1) }
            .onChange(of: makeText) { set(\.make, newValue: $1) }
            .onChange(of: numberPlateText) { set(\.numberPlate, newValue: $1) }
            .onChange(of: vehicleColor) { viewModel.set(color: $1) }
    }

}

// MARK: - Private methods
private extension VehicleDetailsView {
    @ViewBuilder
    var contentView: some View {
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
                onDelete: { indexSet in
                    viewModel.deleteFields(at: indexSet)
                    if viewModel.customFields.isEmpty {
                        editMode?.wrappedValue = .inactive
                    }
                }
            )
        }
    }
    
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
        
        viewModel.addCustomField(
            labelText: key,
            valueText: value
        )
    }
    
    func set(_ keyPath: WritableKeyPath<Vehicle, String>, newValue: String) {
        viewModel.set(text: newValue, keyPath: keyPath)
    }
}
