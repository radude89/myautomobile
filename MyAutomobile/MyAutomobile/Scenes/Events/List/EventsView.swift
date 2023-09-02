//
//  EventsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct EventsView: View {
    
    @Environment(\.editMode) private var editMode

    @StateObject private var viewModel: EventsViewModel

    @State private var showAddView = false
    @State private var sort: Int = 0
    
    init(viewModel: EventsViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Events")
                .eventsToolbar(hasEvents: viewModel.hasEvents, sort: $sort) {
                    showAddView.toggle()
                }
                .sheet(isPresented: $showAddView) {
                    EventAddView(viewModel: .init(vehicles: viewModel.vehicles))
                }
        }
    }
    
}

private extension EventsView {
    @ViewBuilder
    var contentView: some View {
        if viewModel.hasEvents {
            listContentView
        } else {
            emptyView
        }
    }
    
    var emptyView: some View {
        Text("You haven't added any events.")
            .font(.body)
            .multilineTextAlignment(.center)
    }
    
    var listContentView: some View {
        if sort == 1 {
            return AnyView(byVehiclesContentView)
        }
        else {
            return AnyView(allVehiclesContentView)
        }
    }
    
    var allVehiclesContentView: some View {
        List {
            ForEach(viewModel.allEvents) { event in
                EventRowView(event: event)
            }
            .onDelete(perform: viewModel.delete)
        }
    }
    
    var byVehiclesContentView: some View {
        List {
            ForEach(viewModel.vehicles.items) { vehicle in
                Section {
                    ForEach(viewModel.events(for: vehicle)) { event in
                        EventRowView(event: event)
                    }
                } header: {
                    Text("\(vehicle.numberPlate)")
                }
            }
            .onDelete(perform: viewModel.delete)
        }
    }
}
