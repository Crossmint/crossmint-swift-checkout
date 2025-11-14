//
//  CrossmintWebView.swift
//  crossmint-ios-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import SwiftUI
import WebKit
import UIKit

struct CrossmintWebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.applicationNameForUserAgent = "iOSPOCApp"
        
        let osVersion = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
        let safariVersion = String(Int(Double(UIDevice.current.systemVersion) ?? 0) / 2)
        let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS \(osVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(safariVersion).0 Mobile/15E148 Safari/604.1"
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = userAgent
        webView.scrollView.isScrollEnabled = false
        
        context.coordinator.webView = webView
        webView.navigationDelegate = context.coordinator
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var webView: WKWebView?
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
    }
}

