//
//  CrossmintEmbeddedCheckout.swift
//  crossmint-ios-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import SwiftUI

struct CrossmintEmbeddedCheckout: View {
    let lineItems: LineItems
    let payment: Payment
    let recipient: Recipient
    let apiKey: String
    let amount: String
    
    @State private var checkoutUrl: String?
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if let error = errorMessage {
                VStack(spacing: 20) {
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else if let url = checkoutUrl {
                CrossmintWebView(url: url)
            } else {
                ProgressView("Loading checkout...")
            }
        }
        .task {
            await loadCheckout()
        }
    }
    
    private func loadCheckout() async {
        do {
            let config = CrossmintCheckoutConfig(
                lineItems: lineItems,
                payment: payment,
                recipient: recipient,
                apiKey: apiKey
            )
            
            let url = try await CrossmintAPI.generateCheckoutUrl(config: config, amount: amount)
            checkoutUrl = url
        } catch {
            errorMessage = "Failed to load checkout: \(error.localizedDescription)"
        }
    }
}

