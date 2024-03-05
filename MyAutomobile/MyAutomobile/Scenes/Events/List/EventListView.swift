//
//  EventListView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct EventListView: View {
    
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var storeManager: EventStoreManager

    @StateObject private var viewModel: EventListViewModel
    
    @State private var showAddView = false
    @State private var sortOption = 0
    
    init(viewModel: EventListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Events")
                .eventListToolbar(hasVehicles: viewModel.hasVehicles, hasEvents: viewModel.hasEvents, sort: $sortOption) {
                    showAddView.toggle()
                }
                .sheet(isPresented: $showAddView) {
                    EventAddView(viewModel: .init(
                        vehicles: viewModel.vehicles, eventStoreManager: viewModel.eventStoreManager
                    ))
                }
        }
    }
    
}

private extension EventListView {
    @ViewBuilder
    var contentView: some View {
        if viewModel.hasEvents {
            listContentView
        } else {
            emptyView
        }
    }
    
    var emptyView: some View {
        Text("events_empty")
            .font(.body)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing], 32)
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
                EventListRowView(event: event)
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.deleteEvent(at: indexSet)
                }
            }
        }
    }
    
    var byVehiclesContentView: some View {
        List {
            ForEach(0..<viewModel.vehicles.items.count, id: \.self) { section in
                let vehicle = viewModel.vehicles.items[section]
                Section {
                    ForEach(viewModel.events(for: vehicle)) { event in
                        EventListRowView(event: event)
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
