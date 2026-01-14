//
//  CrossmintEmbeddedCheckout.swift
//  crossmint-swift-checkout
//
//  Simplified embedded checkout component using webview
//

import SwiftUI

public struct CrossmintEmbeddedCheckout: View {
    private let orderId: String?
    private let clientSecret: String?
    private let lineItems: CheckoutLineItems?
    private let payment: CheckoutPayment?
    private let recipient: CheckoutRecipient?
    private let apiKey: String?
    private let appearance: CheckoutAppearance?
    private let environment: CheckoutEnvironment

    public init(
        orderId: String? = nil,
        clientSecret: String? = nil,
        lineItems: CheckoutLineItems? = nil,
        payment: CheckoutPayment? = nil,
        recipient: CheckoutRecipient? = nil,
        apiKey: String? = nil,
        appearance: CheckoutAppearance? = nil,
        environment: CheckoutEnvironment = .staging
    ) {
        self.orderId = orderId
        self.clientSecret = clientSecret
        self.lineItems = lineItems
        self.payment = payment
        self.recipient = recipient
        self.apiKey = apiKey
        self.appearance = appearance
        self.environment = environment
    }

    public var body: some View {
        switch checkoutUrlResult {
        case .success(let url):
            CheckoutWebView(url: url)
        case .failure(let error):
            VStack(spacing: 20) {
                Text("Error")
                    .font(.headline)
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }

    private var checkoutUrlResult: Result<String, Error> {
        Result { try generateCheckoutUrl() }
    }

    private func generateCheckoutUrl() throws -> String {
        // TODO: Implement lineItems and recipient
        if lineItems != nil {
            throw CheckoutError.notImplemented("Crossmint Checkout: passing lineItems is not yet implemented")
        }

        if recipient != nil {
            throw CheckoutError.notImplemented("Crossmint Checkout: passing recipient is not yet implemented")
        }

        let domain = environment == .production ? "www" : "staging"
        let baseUrl = "https://\(domain).crossmint.com/sdk/2024-03-05/embedded-checkout"

        guard var components = URLComponents(string: baseUrl) else {
            throw CheckoutError.invalidConfiguration("Invalid base URL")
        }

        var queryItems: [URLQueryItem] = []

        // SDK metadata (standalone demo version)
        let sdkMetadata = ["name": "crossmint-swift-checkout-demo", "version": "1.0.0"]
        queryItems.append(URLQueryItem(name: "sdkMetadata", value: try sdkMetadata.toJSON()))

        if let orderId = orderId {
            queryItems.append(URLQueryItem(name: "orderId", value: orderId))
        }

        if let clientSecret = clientSecret {
            queryItems.append(URLQueryItem(name: "clientSecret", value: clientSecret))
        }

        if let payment = payment {
            queryItems.append(URLQueryItem(name: "payment", value: try payment.toJSON()))
        }

        if let appearance = appearance {
            queryItems.append(URLQueryItem(name: "appearance", value: try appearance.toJSON()))
        }

        components.queryItems = queryItems

        guard let url = components.url?.absoluteString else {
            throw CheckoutError.invalidConfiguration("Failed to construct URL")
        }

        print("[CrossmintCheckout] URL: \(url)")

        return url
    }
}

public enum CheckoutEnvironment {
    case staging
    case production
}

// MARK: - Encodable Extension

extension Encodable {
    func toJSON() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes]
        let data = try encoder.encode(self)
        guard let json = String(data: data, encoding: .utf8) else {
            throw CheckoutError.invalidConfiguration("Failed to encode JSON")
        }
        return json
    }
}
