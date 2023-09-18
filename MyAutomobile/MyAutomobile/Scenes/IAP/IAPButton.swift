//
//  IAPButton.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.09.2023.
//

import SwiftUI

struct IAPButton: View {
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            VStack(spacing: 10) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .bold()
                    Image(systemName: "car")
                }
                Text(subtitle)
                    .font(.callout)
            }
            .padding([.top, .bottom], 5)
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.borderedProminent)
        .tint(Color("app_green"))
    }
}

#Preview {
    IAPButton(title: "1x", subtitle: "One vehicle pack - 1.99$") {}
}
