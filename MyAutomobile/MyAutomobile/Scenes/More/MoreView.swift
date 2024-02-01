//
//  MoreView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

@MainActor
struct MoreView: View {
    @StateObject private var viewModel: MoreViewModel
    
    init(viewModel: MoreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

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
            ExpenseTrackingMoreItem(
                viewModel: .init(vehicles: viewModel.vehicles)
            )
        } header: {
            Text("Utils")
        }
    }
}
