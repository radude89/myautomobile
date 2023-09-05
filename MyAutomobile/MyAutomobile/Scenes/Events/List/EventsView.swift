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
    @State private var sortOption = 0
    
    init(viewModel: EventsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Events")
                .eventsToolbar(hasVehicles: viewModel.hasVehicles, hasEvents: viewModel.hasEvents, sort: $sortOption) {
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
        Text("You haven't added any events.\nYou need to add at least one car to be able to add events.")
            .font(.body)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing])
    }
    
    var listContentView: some View {
        if sortOption == 1 {
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
            .onDelete(perform: viewModel.deleteEvent)
        }
    }
    
    var byVehiclesContentView: some View {
        List {
            ForEach(0..<viewModel.vehicles.items.count, id: \.self) { section in
                let vehicle = viewModel.vehicles.items[section]
                Section {
                    ForEach(viewModel.events(for: vehicle)) { event in
                        EventRowView(event: event)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteEvent(forVehicle: vehicle, at: indexSet)
                    }
                } header: {
                    Text("\(vehicle.numberPlate)")
                }
            }
        }
    }
}
