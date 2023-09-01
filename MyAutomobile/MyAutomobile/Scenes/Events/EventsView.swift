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
                .navigationDestination(for: Event.self) { event in
                    Text("Event details \(event.description)")
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showAddView.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if viewModel.hasEvents {
                            HStack {
                                Menu {
                                    Picker(selection: $sort, label: Text("Sorting options")) {
                                        Text("All").tag(0)
                                        Text("By Vehicle").tag(1)
                                    }
                                }
                            label: {
                                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                            }
                                EditButton()
                            }
                        }
                    }
                }
                .sheet(isPresented: $showAddView) {
                    Text("Add View")
                }

        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.hasEvents {
            listContentView
        } else {
            emptyView
        }
    }
    
    private var emptyView: some View {
        Text("You haven't added any events.")
            .font(.body)
            .multilineTextAlignment(.center)
    }
    
    private var listContentView: some View {
        if sort == 1 {
            return AnyView(byVehiclesContentView)
        }
        else {
            return AnyView(allVehiclesContentView)
        }
    }
    
    private var allVehiclesContentView: some View {
        List {
            ForEach(viewModel.allEvents) { event in
                NavigationLink(value: event) {
                    Text(event.description)
                }
            }
            .onDelete(perform: viewModel.delete)
        }
    }
    
    private var byVehiclesContentView: some View {
        List {
            ForEach(viewModel.vehicles.items) { vehicle in
                Section {
                    ForEach(vehicle.events) { event in
                        Text(event.description)
                    }
                } header: {
                    Text("\(vehicle.numberPlate)")
                }
            }
            .onDelete(perform: viewModel.delete)
        }
    }
    
}
