//
//  EventsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct EventsView: View {
    
    @State private var events = [Event]()
    
    var body: some View {
        NavigationView {
            List(events) { event in
                Text(event.description)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Events")
            .listStyle(.plain)
            .onAppear(perform: loadEvents)
        }
    }
    
    private func loadEvents() {
        events = [
            Event(date: Date(), description: "ITP"),
            Event(date: Date(), description: "CASCO"),
            Event(date: Date(), description: "Rata masina"),
            Event(date: Date(), description: "Extinctor"),
            Event(date: Date(), description: "Rovinieta")
        ]
    }
    
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
