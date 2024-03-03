//
//  MoreView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI
import MessageUI

@MainActor
struct MoreView: View {
    @StateObject private var viewModel: MoreViewModel
    @State private var showEmailWasSentAlert = false
    @Environment(\.requestReview) private var requestReview
    
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
            contactSection
            termsSection
            versionSection
        }
    }
    
    static let itemHeight: CGFloat = 40

    var utilsSection: some View {
        Section {
            makeItemView(for: .expenses, imageName: "pencil.line")
                .frame(minHeight: Self.itemHeight)
            makeItemView(for: .maintenance, imageName: "screwdriver.fill")
                .frame(minHeight: Self.itemHeight)
            FuelConsumptionView(viewModel: .init())
                .frame(minHeight: Self.itemHeight)
        } header: {
            Text("Utils")
        }
    }
    
    var contactSection: some View {
        Section {
            if MFMailComposeViewController.canSendMail() {
                emailItemView
            }
            Label("Review the app", systemImage: "steeringwheel.circle.fill")
                .frame(minHeight: Self.itemHeight)
                .onTapGesture {
                    requestReview()
                }
        } header: {
            Text("Feedback")
        }
    }
    
    var termsSection: some View {
        Section {
            TermsView(viewModel: .init(
                title: "Terms & Conditions",
                imageName: "folder.fill",
                isShowingTerms: true
            ))
            .frame(minHeight: Self.itemHeight)
            
            TermsView(viewModel: .init(
                title: "Privacy Policy",
                imageName: "newspaper.fill",
                isShowingTerms: false
            ))
            .frame(minHeight: Self.itemHeight)
        } header: {
            Text("Terms")
        }
    }
    
    var versionSection: some View {
        Section {
            Text(viewModel.footnote)
                .textSelection(.enabled)
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .listRowBackground(Color.clear)
    }
    
    var emailItemView: some View {
        EmailItemView(
            emailSubject: viewModel.emailSubject,
            itemHeight: Self.itemHeight,
            showEmailWasSentAlert: $showEmailWasSentAlert
        )
        .alert("Email was sent", isPresented: $showEmailWasSentAlert) {
            Button("OK", role: .cancel) {
                showEmailWasSentAlert = false
            }
        }
    }
    
    func makeItemView(for item: MoreItem, imageName: String) -> some View {
        MoreUtilsItemView(
            viewModel: .init(
                vehicles: viewModel.vehicles,
                title: viewModel.title(for: item),
                imageName: imageName,
                emptyViewTitle: viewModel.emptyViewTitle(for: item)
            )
        ) { vehicle in
            makeDetailsView(for: item, vehicleID: vehicle.id)
        }
    }
    
    @ViewBuilder 
    func makeDetailsView(
        for item: MoreItem,
        vehicleID: UUID
    ) -> some View {
        switch item {
        case .expenses:
            ExpenseTrackingView(
                viewModel: .init(
                    vehicles: viewModel.vehicles,
                    vehicleID: vehicleID
                )
            )
        case .maintenance:
            ExpenseTrackingView(
                viewModel: .init(
                    vehicles: viewModel.vehicles,
                    vehicleID: vehicleID,
                    showOnlyMaintenanceItems: true
                )
            )
        }
    }
}
