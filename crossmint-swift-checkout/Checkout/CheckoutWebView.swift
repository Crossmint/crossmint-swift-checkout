//
//  CheckoutWebView.swift
//  crossmint-swift-checkout
//
//  WebKit component for rendering Crossmint embedded checkout
//

import SwiftUI
import WebKit

struct CheckoutWebView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        // Media playback
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // Inject viewport meta tag to prevent zooming
        let viewportScript = """
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        document.getElementsByTagName('head')[0].appendChild(meta);
        """
        let userScript = WKUserScript(
            source: viewportScript,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        config.userContentController.addUserScript(userScript)

        // Set content mode
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        config.applicationNameForUserAgent = "CrossmintCheckout"

        let webView = WKWebView(frame: .zero, configuration: config)

        // Disable scrolling and bouncing
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.alwaysBounceHorizontal = false

        // Enable multiple touch for payment forms
        webView.isMultipleTouchEnabled = true

        // Set background
        webView.isOpaque = false
        webView.backgroundColor = .clear

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

    class Coordinator: NSObject, WKNavigationDelegate {}
}
