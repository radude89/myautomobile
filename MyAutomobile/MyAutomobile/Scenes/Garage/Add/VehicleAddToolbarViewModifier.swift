//
//  VehicleAddToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 24.08.2023.
//

import SwiftUI

struct VehicleAddToolbarViewModifier: ViewModifier {
    @Environment(\.presentationMode) private var presentationMode
    @State private var isPresentingConfirmation = false
    
    let onDone: () -> Void
    let isDoneButtonDisabled: Bool
    let hasChanges: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            isPresentingConfirmation = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .confirmationDialog(
                        "Are you sure you want to discard this new vehicle?",
                        isPresented: $isPresentingConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Discard changes", role: .destructive) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        Button("Keep editing", role: .cancel) {
                            isPresentingConfirmation = false
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDone()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .bold()
                    .disabled(isDoneButtonDisabled)
                }
            }
    }
}

extension View {
    func vehicleAddToolbar(
        isDoneButtonDisabled: Bool,
        hasChanges: Bool,
        onDone: @escaping () -> Void) -> some View {
        modifier(
            VehicleAddToolbarViewModifier(
                onDone: onDone,
                isDoneButtonDisabled: isDoneButtonDisabled,
                hasChanges: hasChanges
            )
        )
    }
}
