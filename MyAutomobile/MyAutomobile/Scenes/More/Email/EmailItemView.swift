//
//  EmailItemView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.03.2024.
//

import SwiftUI

struct EmailItemView: View {
    @State private var showSendEmailView = false
    
    private let emailSubject: String
    private let itemHeight: CGFloat
    
    @Binding var showEmailWasSentAlert: Bool
    
    init(emailSubject: String, 
         itemHeight: CGFloat,
         showEmailWasSentAlert: Binding<Bool>
    ) {
        self.itemHeight = itemHeight
        self.emailSubject = emailSubject
        _showEmailWasSentAlert = showEmailWasSentAlert
    }

    var body: some View {
        Label("Drop me (🥸) an email", systemImage: "mail.fill")
            .frame(minHeight: itemHeight)
            .onTapGesture {
                showSendEmailView.toggle()
            }
            .sheet(isPresented: $showSendEmailView) {
                SendEmailView(subject: emailSubject) { emailWasSent in
                    showSendEmailView = false
                    if emailWasSent {
                        showEmailWasSentAlert.toggle()
                    }
                }
            }
    }
}
