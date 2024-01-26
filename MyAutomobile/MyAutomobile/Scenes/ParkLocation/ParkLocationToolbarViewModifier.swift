//
//  ParkLocationToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 24.01.2024.
//

import SwiftUI

struct ParkLocationToolbarViewModifier: ViewModifier {
    let clearButtonIsDisabled: Bool
    let onTapInfo: () -> Void
    let onTapClear: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear", action: onTapClear)
                        .disabled(clearButtonIsDisabled)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onTapInfo) {
                        Image(systemName: "info.circle")
                    }
                }
            }
    }
}

extension View {
    func parkLocationToolbar(
        clearButtonIsDisabled: Bool,
        onTapInfo: @escaping () -> Void,
        onTapClear: @escaping () -> Void
    ) -> some View {
        modifier(
            ParkLocationToolbarViewModifier(
                clearButtonIsDisabled: clearButtonIsDisabled,
                onTapInfo: onTapInfo,
                onTapClear: onTapClear
            )
        )
    }
}
