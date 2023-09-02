//
//  VehicleTitle.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.07.2022.
//

import SwiftUI

struct VehicleTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .bold()
            .foregroundColor(.primary)
    }
}

extension View {
    var titleStyle: some View {
        modifier(VehicleTitle())
    }
}
