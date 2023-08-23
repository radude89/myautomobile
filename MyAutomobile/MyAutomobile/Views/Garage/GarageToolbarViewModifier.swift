//
//  GarageToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.08.2023.
//

import SwiftUI

struct GarageToolbarViewModifier: ViewModifier {
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
    func garageToolbar(hasVehicles: Bool, onAdd: @escaping () -> Void) -> some View {
        modifier(
            GarageToolbarViewModifier(
                hasVehicles: hasVehicles,
                onAdd: onAdd
            )
        )
    }
}
