//
//  SendEmailView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.03.2024.
//

import SwiftUI
import MessageUI

struct SendEmailView: UIViewControllerRepresentable {
    private let subject: String
    private let onDismiss: (Bool) -> Void

    init(subject: String, onDismiss: @escaping (Bool) -> Void) {
        self.subject = subject
        self.onDismiss = onDismiss
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setSubject(subject)
        viewController.setToRecipients(["danradu.ro@gmail.com"])
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }
}

extension SendEmailView {
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let onDismiss: (Bool) -> Void
        
        init(onDismiss: @escaping (Bool) -> Void) {
            self.onDismiss = onDismiss
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            if let error {
                print(error)
                onDismiss(false)
                return
            }
            switch result {
            case .sent:
                onDismiss(true)
            default:
                onDismiss(false)
            }
        }
    }
}
