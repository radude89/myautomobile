//
//  EventAddView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

struct EventAddView: View {
    
    @StateObject private var viewModel: EventAddViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var titleText = ""
    @State private var recurrenceIndex = 0
    @State private var date: Date = .now
    @State private var vehicleIndex = 0
    @State private var addEventToLocalCalendar = true
    @State private var showSuccessAlert = false
    @State private var showLocalCalendarView = false

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
                    confirmationTitle: "alert_confirmation_event_discard_title",
                    onDone: saveEvent
                )
                .interactiveDismissDisabled(hasChanges)
                .task {
                    await viewModel.setupEventStore()
                }
                .alert("Event was saved", isPresented: $showSuccessAlert) {
                    Button("OK") {
                        if addEventToLocalCalendar {
                            showLocalCalendarView = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } message: {
                    Text("alert_event_info")
                }
                .sheet(isPresented: $showLocalCalendarView) {
                    EventEditViewController(
                        event: viewModel.makeEKEvent(),
                        dataStore: viewModel.dataStore
                    ) { eventID in
                        viewModel.set(eventLocalID: eventID)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
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
            addEventToLocalCalendar: $addEventToLocalCalendar,
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
        showSuccessAlert = true
    }
}
