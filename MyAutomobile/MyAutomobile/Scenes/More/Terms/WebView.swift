//
//  WebView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 03.03.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebView {
    final class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
    }
}
