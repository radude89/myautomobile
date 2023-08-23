//
//  EventsViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.07.2022.
//
import Foundation

final class EventsViewModel: ObservableObject {
    
    @Published private(set) var events: [Event]
    
    init(events: [Event] = .demoEvents) {
        self.events = events
    }
    
    var hasEvents: Bool {
        events.isEmpty
    }
    
    func delete(atOffsets offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }
    
}
