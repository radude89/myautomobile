//
//  GarageViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import SwiftUI

final class GarageViewModel: ObservableObject {
    
    @ObservedObject var vehicles = Vehicles()
    
    var hasVehicles: Bool {
        !vehicles.items.isEmpty
    }
    
    func delete(atOffsets offsets: IndexSet) {
        vehicles.items.remove(atOffsets: offsets)
        objectWillChange.send()
    }
    
}
