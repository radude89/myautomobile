//
//  EventsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct EventsView: View {
    
    @State private var events: [Event]
    @State private var editMode: EditMode
    
    init(
        events: [Event] = [],
        editMode: EditMode = .inactive
    ) {
        _events = State(initialValue: events)
        _editMode = State(initialValue: editMode)
    }
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Events")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !events.isEmpty {
                            EditButton()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Add...")
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if events.isEmpty {
            Text("You haven't added any events.")
                .font(.body)
                .multilineTextAlignment(.center)
        } else {
            List(events) { event in
                Text(event.description)
            }
        }
    }
    
}

// MARK: - Previews

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(events: .demoEvents)
        
        EventsView()
            .preferredColorScheme(.dark)
    }
}
