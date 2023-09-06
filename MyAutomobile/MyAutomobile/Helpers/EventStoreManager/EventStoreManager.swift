/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The data model for the app.
*/

import EventKit

@MainActor
class EventStoreManager: ObservableObject {
    /// Contains fetched events when the app receives a full-access authorization status.
    @Published var events: [EKEvent]
    
    /// Specifies the authorization status for the app.
    @Published var authorizationStatus: EKAuthorizationStatus
    
    let dataStore: EventDataStore
    
    init(store: EventDataStore = EventDataStore()) {
        self.dataStore = store
        self.events = []
        self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    func setupEventStore() async throws {
        _ = try await dataStore.verifyAuthorizationStatus()
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    func removeEvents(_ events: [EKEvent]) async throws {
        try await dataStore.removeEvents(events)
    }
}
