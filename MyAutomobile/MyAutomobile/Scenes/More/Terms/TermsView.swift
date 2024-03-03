//
//  TermsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.03.2024.
//

import SwiftUI

struct TermsView: View {
    @State private var showLoadingView = true
    
    private let viewModel: TermsViewModel
    private static let delay: TimeInterval = 2
    
    init(viewModel: TermsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationLink {
            contentView
                .navigationTitle(viewModel.title)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Self.delay) {
                        showLoadingView = false
                    }
                }
        } label: {
            Label(viewModel.title, systemImage: viewModel.imageName)
        }
    }
}

private extension TermsView {
    @ViewBuilder
    var contentView: some View {
        ZStack {
            webView
                .opacity(showLoadingView ? 0 : 1)
            if showLoadingView {
                loadingView
            }
        }
    }
    
    var loadingView: some View {
        ProgressView() {
            Text("Loading...")
        }
        .progressViewStyle(.circular)
    }
    
    var webView: some View {
        WebView(url: viewModel.url)
    }
}
