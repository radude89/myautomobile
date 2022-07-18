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
                        if !viewModel.hasEvents {
                            EditButton()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddView.toggle()
                        } label: {
                            Image(systemName: "plus")
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
            Text("You haven't added any events.")
                .font(.body)
                .multilineTextAlignment(.center)
        } else {
            List {
                ForEach(viewModel.events) { event in
                    NavigationLink(value: event) {
                        Text(event.description)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
        }
    }
    
}

// MARK: - Previews

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(viewModel: .init(events: .demoEvents))
        
        EventsView(viewModel: .init(events: []))
            .preferredColorScheme(.dark)
    }
}
