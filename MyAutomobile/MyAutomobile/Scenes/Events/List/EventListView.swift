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
    @State private var isEditing = false

    init(viewModel: EventListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Events")
                .eventListToolbar(
                    hasVehicles: viewModel.hasVehicles,
                    hasEvents: viewModel.hasEvents,
                    sortOption: $sortOption,
                    isEditing: $isEditing
                ) {
                    showAddView.toggle()
                }
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .sheet(isPresented: $showAddView) {
                    EventAddView(viewModel: .init(
                        vehicles: viewModel.vehicles,
                        eventStoreManager: viewModel.eventStoreManager
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
        switch EventListSortOption(rawValue: sortOption) {
        case .all:
            AnyView(allVehiclesContentView)
        case .byVehicle:
            AnyView(byVehiclesContentView)
        default:
            AnyView(emptyView)
        }
    }

    var allVehiclesContentView: some View {
        List {
            ForEach(viewModel.allEvents) { event in
                EventListRowView(event: event)
                    .listRowBackground(Color.clear)
            }
            .onDelete { indexSet in
                viewModel.deleteEvent(
                    at: indexSet,
                    sortOption: sortOption
                )
                Task { @MainActor in
                    if !viewModel.hasEvents {
                        isEditing = false
                    }
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
                            .listRowBackground(Color.clear)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteEvent(
                            at: indexSet,
                            sortOption: sortOption,
                            section: section
                        )
                        Task { @MainActor in
                            if !viewModel.hasEvents {
                                isEditing = false
                            }
                        }
                    }
                } header: {
                    Text("\(vehicle.numberPlate)")
                }
            }
        }
    }
}
