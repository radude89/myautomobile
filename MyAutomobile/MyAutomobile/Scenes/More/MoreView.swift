//
//  MoreView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI
import Observation

@MainActor
struct MoreView: View {
    let viewModel: MoreViewModel

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("More")
        }
    }
}

// MARK: - Private
private extension MoreView {
    var contentView: some View {
        Form {
            utilsSection
        }
    }

    var utilsSection: some View {
        Section {
            ExpenseTrackingMoreItem(vehicles: viewModel.vehicles)
        } header: {
            Text("Utils")
        }
    }
}
