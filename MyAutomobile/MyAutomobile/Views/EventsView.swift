//
//  EventsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct EventsView: View {
    
    @State private var events: [Event]
    
    init(events: [Event] = []) {
        self.events = events
    }
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Events")
        }
    }
    
    private var contentView: some View {
        if events.isEmpty {
            return AnyView(
                Text("You haven't added any events.")
                    .font(.body)
                    .multilineTextAlignment(.center)
            )
        } else {
            return AnyView(
                List(events) { event in
                    Text(event.description)
                }
            )
        }
    }
    
}

struct EventsView_Previews: PreviewProvider {
    private static let events = [
        Event(date: Date(), description: "ITP"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Date(), description: "Rata masina"),
        Event(date: Date(), description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta"),
        Event(date: Date(), description: "ITP"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Date(), description: "Rata masina"),
        Event(date: Date(), description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta"),
        Event(date: Date(), description: "ITP"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Date(), description: "Rata masina"),
        Event(date: Date(), description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta"),
        Event(date: Date(), description: "ITP"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Date(), description: "Rata masina"),
        Event(date: Date(), description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta")
    ]
    
    static var previews: some View {
        EventsView(events: events)
        
        EventsView(events: events)
            .preferredColorScheme(.dark)
        
        EventsView()
            .preferredColorScheme(.dark)
    }
}
