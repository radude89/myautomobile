//
//  EventListToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

struct EventListToolbarViewModifier: ViewModifier {
    let hasVehicles: Bool
    let hasEvents: Bool
    let onAdd: () -> Void
    
    @Binding var sort: Int
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                    }
                    .disabled(!hasVehicles)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if hasEvents {
                        editView
                    }
                }
            }
    }
    
    private var editView: some View {
        HStack {
            Menu {
                Picker(selection: $sort, label: Text("Sorting options")) {
                    Text("All").tag(0)
                    Text("By Vehicle").tag(1)
                }
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }

            EditButton()
        }
    }
}

extension View {
    func eventListToolbar(
        hasVehicles: Bool,
        hasEvents: Bool,
        sort: Binding<Int>,
        onAdd: @escaping () -> Void
    ) -> some View {
        modifier(
            EventListToolbarViewModifier(
                hasVehicles: hasVehicles,
                hasEvents: hasEvents,
                onAdd: onAdd,
                sort: sort
            )
        )
    }
}
