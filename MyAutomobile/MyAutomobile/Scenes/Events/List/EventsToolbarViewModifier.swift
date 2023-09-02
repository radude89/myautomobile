//
//  EventsToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

struct EventsToolbarViewModifier: ViewModifier {
    let hasEvents: Bool
    let onAdd: () -> Void
    
    @Binding var sort: Int
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
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
    func eventsToolbar(
        hasEvents: Bool,
        sort: Binding<Int>,
        onAdd: @escaping () -> Void
    ) -> some View {
        modifier(
            EventsToolbarViewModifier(hasEvents: hasEvents, onAdd: onAdd, sort: sort)
        )
    }
}
