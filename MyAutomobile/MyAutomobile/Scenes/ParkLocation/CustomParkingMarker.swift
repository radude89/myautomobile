import SwiftUI

struct CustomParkingMarker: View {
    var body: some View {
        ZStack {
            // Drop shadow
            Circle()
                .fill(.black.opacity(0.2))
                .frame(width: 50, height: 50)
                .offset(x: 1, y: 2)

            // Main marker background
            Circle()
                .fill(.red)
                .frame(width: 48, height: 48)
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 3)
                )

            // Car icon
            Image(systemName: "car.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
