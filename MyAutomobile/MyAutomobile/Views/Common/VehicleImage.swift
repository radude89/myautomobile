//
//  VehicleImage.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import SwiftUI

struct VehicleImage: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .shadow(radius: 4)
            .overlay(
                Circle()
                    .stroke(.gray, lineWidth: 1)
            )
    }
}

struct VehicleImage_Previews: PreviewProvider {
    static var previews: some View {
        VehicleImage(image: Array.demoVehicles.randomElement()!.icon)
    }
}
