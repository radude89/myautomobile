//
//  VehicleListToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.08.2023.
//

import SwiftUI

struct VehicleListToolbarViewModifier: ViewModifier {
    let hasVehicles: Bool
    @Binding var isEditing: Bool
    let onAdd: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            isEditing.toggle()
                        }
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                    }
                    .disabled(!hasVehicles)
                }
            }
    }
}

extension View {
    func vehicleListToolbar(
        hasVehicles: Bool,
        isEditing: Binding<Bool>,
        onAdd: @escaping () -> Void
    ) -> some View {
        modifier(
            VehicleListToolbarViewModifier(
                hasVehicles: hasVehicles,
                isEditing: isEditing,
                onAdd: onAdd
            )
        )
    }
}
