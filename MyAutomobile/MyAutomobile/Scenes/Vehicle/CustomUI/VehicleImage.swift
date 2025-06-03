//
//  VehicleImage.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import SwiftUI

struct VehicleImage: View {
    let color: Color

    var body: some View {
        Image(systemName: "car")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(.palette)
            .foregroundStyle(color, .secondary)
            .padding(.all, 16)
            .frame(width: 70, height: 70)
            .background(
                Circle()
                    .fill(contrastingBackground(for: color))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                color.opacity(0.3),
                                color.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }

    private func contrastingBackground(for color: Color) -> Color {
        let uiColor = UIColor(color)
        var white: CGFloat = 0
        uiColor.getWhite(&white, alpha: nil)

        return white > 0.6 ? .black.opacity(0.5) : .white.opacity(0.5)
    }
}

struct VehicleImage_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                VehicleImage(color: .cyan)
                VehicleImage(color: .white)
                VehicleImage(color: .black)
                VehicleImage(color: .pink)
                VehicleImage(color: .yellow)
                VehicleImage(color: .green)
                VehicleImage(color: .mint)
                VehicleImage(color: .blue)
            }
        }
    }
}
