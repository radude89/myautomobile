//
//  ExpenseItemView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 13.02.2024.
//

import SwiftUI

struct ExpenseItemView: View {
    let imageName: String
    let color: Color
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .frame(width: 35, height: 35)
            .clipShape(Circle())
            .foregroundStyle(color)
            .overlay(Circle().stroke(Color.primary.opacity(0.2), lineWidth: 0.5))
    }
}
