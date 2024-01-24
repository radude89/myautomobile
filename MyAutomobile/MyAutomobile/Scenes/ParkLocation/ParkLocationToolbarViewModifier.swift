//
//  ParkLocationToolbarViewModifier.swift
//  MyAutomobile
//
//  Created by Radu Dan on 24.01.2024.
//

import SwiftUI

struct ParkLocationToolbarViewModifier: ViewModifier {
    let onTapInfo: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
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
        onTapInfo: @escaping () -> Void
    ) -> some View {
        modifier(
            ParkLocationToolbarViewModifier(onTapInfo: onTapInfo)
        )
    }
}
