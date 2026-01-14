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
        let viewportUserScript = WKUserScript(
            source: viewportScript,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        config.userContentController.addUserScript(viewportUserScript)

        // Inject CSS to customize Apple Pay button (using MutationObserver to catch dynamic elements)
        let applePayStyleScript = """
        (function() {
            // Create and inject style
            var style = document.createElement('style');
            style.textContent = `
                apple-pay-button {
                    --apple-pay-button-border-radius: 24px !important;
                    --apple-pay-button-height: 48px !important;
                }
            `;
            document.head.appendChild(style);
            
            // Also try to apply directly when elements appear
            var observer = new MutationObserver(function(mutations) {
                var buttons = document.querySelectorAll('apple-pay-button');
                buttons.forEach(function(btn) {
                    btn.style.setProperty('--apple-pay-button-border-radius', '24px', 'important');
                });
            });
            
            observer.observe(document.body, { childList: true, subtree: true });
            
            // Initial check
            setTimeout(function() {
                var buttons = document.querySelectorAll('apple-pay-button');
                buttons.forEach(function(btn) {
                    btn.style.setProperty('--apple-pay-button-border-radius', '24px', 'important');
                });
            }, 1000);
        })();
        """
        let applePayUserScript = WKUserScript(
            source: applePayStyleScript,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        config.userContentController.addUserScript(applePayUserScript)

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
