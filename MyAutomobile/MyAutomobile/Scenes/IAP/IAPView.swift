//
//  IAPView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.09.2023.
//

import SwiftUI

struct IAPView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("iap.title")
                .padding([.leading, .trailing, .bottom])
            VStack(spacing: 20) {
                IAPButton(title: "1x", subtitle: "One vehicle pack - 1.99$") {}
                IAPButton(title: "3x", subtitle: "Three vehicles pack - 2.99$") {}
                IAPButton(title: "5x", subtitle: "Five vehicles pack - 4.99$") {}
                IAPButton(title: "∞ x", subtitle: "Unlimited vehicles pack - 9.99$") {}
                Button(action: {}, label: {
                    Text("Restore purchases")
                        .bold()
                })
                .padding()
                .foregroundStyle(.pink)
                .backgroundStyle(.pink)
                .overlay(
                    RoundedRectangle(cornerRadius: 6.0)
                        .stroke(.pink, lineWidth: 1.0)
                )
                
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}

#Preview {
    IAPView()
}
