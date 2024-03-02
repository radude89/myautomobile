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
    @State private var showSendEmailView = false
    @State private var showEmailWasSentAlert = false
    
    init(viewModel: MoreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("More")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Text(viewModel.footnote)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .textSelection(.enabled)
                    }
                }
        }
    }
}

// MARK: - Private
private extension MoreView {
    var contentView: some View {
        Form {
            utilsSection
            contactSection
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
                sendEmailView
            }
        } header: {
            Text("Contact")
        }
    }
    
    var sendEmailView: some View {
        Label("Drop me (🥸) an email", systemImage: "mail.fill")
            .frame(minHeight: Self.itemHeight)
            .onTapGesture {
                showSendEmailView.toggle()
            }
            .sheet(isPresented: $showSendEmailView) {
                SendEmailView(subject: viewModel.emailSubject) { emailWasSent in
                    showSendEmailView = false
                    if emailWasSent {
                        showEmailWasSentAlert.toggle()
                    }
                }
            }
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
