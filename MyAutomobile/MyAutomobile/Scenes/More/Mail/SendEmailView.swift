//
//  SendEmailView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.03.2024.
//

import SwiftUI
import MessageUI

struct SendEmailView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

extension SendEmailView {
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Environment(\.dismiss) private var dismiss

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                dismiss()
            }
            
            if let error {
                print(error)
                return
            }
        }
    }
}
