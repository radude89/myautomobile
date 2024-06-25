//
//  VehicleListViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import SwiftUI
import EventKit

final class VehicleListViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    private let eventStoreManager: EventStoreManager
    private let purchaseManager: PurchaseManager
    
    init(vehicles: Vehicles, eventStoreManager: EventStoreManager, purchaseManager: PurchaseManager) {
        self.vehicles = vehicles
        self.eventStoreManager = eventStoreManager
        self.purchaseManager = purchaseManager
    }
    
    var hasVehicles: Bool {
        !vehicles.items.isEmpty
    }
    
    var canPresentAddView: Bool {
        if hasBoughtUnlimitedVehicles {
            print("Has bought unlimited vehicles.")
            return true
        }

        return purchaseManager.purchasedVehicleSlots > vehicles.items.count
    }
    
    var numberOfAddedVehicles: Int {
        vehicles.items.count
    }
    
    var availableSlots: Int {
        purchaseManager.purchasedVehicleSlots
    }
    
    var hasBoughtUnlimitedVehicles: Bool {
        purchaseManager.hasBoughtUnlimitedVehicles
    }
    
    func delete(atOffsets offsets: IndexSet) {
        if let firstIndex = offsets.first {
            let vehicle = vehicles.items[firstIndex]
            deleteEKEvents(for: vehicle)
        }
        vehicles.items.remove(atOffsets: offsets)
        objectWillChange.send()
    }
    
    private func deleteEKEvents(for vehicle: Vehicle) {
        let eventIDs = vehicle.events.compactMap { $0.localCalendarID }
        do {
            try eventStoreManager.removeEvents(withIDs: eventIDs)
        } catch {
            print(error)
        }
    }
    
}
