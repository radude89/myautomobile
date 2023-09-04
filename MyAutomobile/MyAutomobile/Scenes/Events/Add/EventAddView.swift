//
//  EventAddView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

struct EventAddView: View {
    
    @StateObject private var viewModel: EventAddViewModel
    
    @State private var titleText = ""
    @State private var recurrenceIndex = 0
    @State private var date: Date = .now
    @State private var vehicleIndex = 0
    
    init(viewModel: EventAddViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationBarTitle("Add your event")
                .addToolbar(
                    isDoneButtonDisabled: doneButtonIsDisabled,
                    hasChanges: hasChanges,
                    confirmationTitle: "Are you sure you want to discard this new event?",
                    onDone: saveEvent
                )
                .interactiveDismissDisabled(hasChanges)
        }
    }
    
}

private extension EventAddView {
    var contentView: some View {
        EventAddFormView(
            selectedVehicleIndex: $vehicleIndex,
            recurrenceIndex: $recurrenceIndex,
            date: $date,
            titleText: $titleText,
            vehicles: viewModel.vehicles.items
        )
    }
    
    var doneButtonIsDisabled: Bool {
        titleText.isEmpty
    }
    
    var hasChanges: Bool {
        !titleText.isEmpty
    }
    
    func saveEvent() {
        viewModel.saveEvent(
            date: date,
            titleText: titleText,
            recurrenceIndex: recurrenceIndex,
            vehicleIndex: vehicleIndex
        )
    }
}
