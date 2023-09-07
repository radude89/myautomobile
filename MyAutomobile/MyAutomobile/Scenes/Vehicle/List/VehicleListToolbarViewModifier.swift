//
//  VehicleListToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.08.2023.
//

import SwiftUI

struct VehicleListToolbarViewModifier: ViewModifier {
    let hasVehicles: Bool
    let onAdd: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if hasVehicles {
                        EditButton()
                    }
                }
            }
    }
}

extension View {
    func vehicleListToolbar(hasVehicles: Bool, onAdd: @escaping () -> Void) -> some View {
        modifier(
            VehicleListToolbarViewModifier(
                hasVehicles: hasVehicles,
                onAdd: onAdd
            )
        )
    }
}
