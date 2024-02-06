//
//  ExpenseRowView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 06.02.2024.
//

import SwiftUI

struct ExpenseRowView: View {
    private let viewModel: ExpenseRowViewModel
    
    init(viewModel: ExpenseRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: viewModel.imageName)
                .resizable()
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .foregroundStyle(viewModel.color)
                .overlay(Circle().stroke(Color.primary.opacity(0.2), lineWidth: 0.5))
                .padding([.trailing], 4)
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.leadingTitle)
                        .bold()
                    Text(viewModel.expenseDate, style: .date)
                        .font(.body)
                    if let comment = viewModel.coment {
                        Text(comment)
                            .font(.body)
                    }
                }
                if let odometerReading = viewModel.odometerReading {
                    Text(odometerReading)
                        .font(.body)
                }
            }
            Spacer()
            Text(viewModel.trailingTitle)
                .bold()
        }
    }
}

// MARK: - Private
private extension ExpenseRowView {
}

// MARK: - Preview
#Preview {
    ExpenseRowView(
        viewModel: .init(
            expense: .init(
                date: .now,
                odometerReading: 123,
                expenseType: .insurance,
                cost: 100.5
            )
        )
    )
}
