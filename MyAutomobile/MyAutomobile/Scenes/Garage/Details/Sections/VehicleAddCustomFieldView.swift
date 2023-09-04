//
//  VehicleAddCustomFieldView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 04.09.2023.
//

import SwiftUI

struct VehicleAddCustomFieldView: View {

    @State private var labelText = ""
    @State private var valueText = ""
    
    let onDone: (String, String) -> Void

    var body: some View {
        contentView
            .navigationBarTitle("Add your custom field")
            .addToolbar(
                isDoneButtonDisabled: doneButtonIsDisabled,
                hasChanges: hasChanges,
                confirmationTitle: "Are you sure you want to discard this new custom field?",
                onDone:  { onDone(labelText, valueText) }
            )
            .interactiveDismissDisabled(hasChanges)
    }

}

private extension VehicleAddCustomFieldView {
    var contentView: some View {
        Form {
            Section {
                TextField("Name of field", text: $labelText)
            } header: {
                Text("Name")
            } footer: {
                Text("A field can be your vehicle's \"Fuel type\".")
            }
            
            Section {
                TextField("Value", text: $valueText)
            } header: {
                Text("Value")
            }  footer: {
                Text("A value can be \"Gas\" if you entered as a name \"Fuel type\".")
            }
        }
    }

    var hasChanges: Bool {
        !labelText.isEmpty || !valueText.isEmpty
    }
    
    var doneButtonIsDisabled: Bool {
        labelText.isEmpty || valueText.isEmpty
    }
}
