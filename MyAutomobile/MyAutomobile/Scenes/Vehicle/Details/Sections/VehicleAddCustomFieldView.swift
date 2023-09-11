//
//  VehicleAddCustomFieldView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 04.09.2023.
//

import SwiftUI

struct VehicleAddCustomFieldView: View {

    @Environment(\.presentationMode) private var presentationMode

    @State private var labelText = ""
    @State private var valueText = ""
    
    let onDone: (String, String) -> Void

    var body: some View {
        contentView
            .navigationBarTitle("Add your custom field")
            .addToolbar(
                isDoneButtonDisabled: doneButtonIsDisabled,
                hasChanges: hasChanges,
                confirmationTitle: "alert_confirmation_custom_field_discard_title",
                onDone: {
                    onDone(labelText, valueText)
                    presentationMode.wrappedValue.dismiss()
                }
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
                Text("footer_custom_field_name")
            }
            
            Section {
                TextField("Value", text: $valueText)
            } header: {
                Text("Value")
            }  footer: {
                Text("footer_custom_field_value")
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
