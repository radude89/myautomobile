//
//  MoreUtilsItemViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.02.2024.
//

import SwiftUI

final class MoreUtilsItemViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    let title: String
    let imageName: String
    let emptyViewTitle: String.LocalizationValue
    
    init(vehicles: Vehicles,
         title: String,
         imageName: String,
         emptyViewTitle: String.LocalizationValue) {
        self.vehicles = vehicles
        self.title = title
        self.imageName = imageName
        self.emptyViewTitle = emptyViewTitle
    }
    
    var items: [Vehicle] {
        vehicles.items
    }
    
    var firstVehicle: Vehicle? {
        vehicles.items.first
    }
    
    var hasMoreThanOneVehicle: Bool {
        items.count > 1
    }
    
}
