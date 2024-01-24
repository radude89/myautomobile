//
//  AddToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 24.08.2023.
//

import SwiftUI

struct AddToolbarViewModifier: ViewModifier {
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var isPresentingConfirmation = false
    
    let onDone: () -> Void
    let isDoneButtonDisabled: Bool
    let hasChanges: Bool
    let confirmationTitle: String.LocalizationValue
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            isPresentingConfirmation = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .confirmationDialog(
                        String(localized: confirmationTitle),
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        onDone()
                    }
                    .bold()
                    .disabled(isDoneButtonDisabled)
                }
            }
    }

}

extension View {
    func addToolbar(
        isDoneButtonDisabled: Bool,
        hasChanges: Bool,
        confirmationTitle: String.LocalizationValue,
        onDone: @escaping () -> Void) -> some View {
            modifier(
                AddToolbarViewModifier(
                    onDone: onDone,
                    isDoneButtonDisabled: isDoneButtonDisabled,
                    hasChanges: hasChanges,
                    confirmationTitle: confirmationTitle
                )
            )
        }
}
