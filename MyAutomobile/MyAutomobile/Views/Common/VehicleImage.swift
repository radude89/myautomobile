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
        Image(systemName: "car.side.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(.palette)
            .foregroundStyle(color)
            .padding(.all, 15)
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.foreground, lineWidth: 0.5)
                    .shadow(radius: 2)
            )
    }
}

struct VehicleImage_Previews: PreviewProvider {
    static var previews: some View {
        VehicleImage(color: .cyan)
    }
}
