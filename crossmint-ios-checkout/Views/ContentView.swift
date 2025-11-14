//
//  ContentView.swift
//  crossmint-ios-checkout
//
//  Main app view - configure checkout component here
//  Created by Robin Curbelo on 11/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CrossmintEmbeddedCheckout(
            lineItems: LineItems(
                tokenLocator: "solana:7EivYFyNfgGj8xbUymR7J4LuxUHLKRzpLaERHLvi7Dgu",
                executionParameters: [
                    "mode": "exact-in",
                    "amount": "1",
                    "maxSlippageBps": "500"
                ]
            ),
            payment: Payment(
                crypto: CryptoPayment(enabled: false),
                fiat: FiatPayment(
                    enabled: true,
                    allowedMethods: AllowedMethods(
                        googlePay: false,
                        applePay: true,
                        card: false
                    )
                ),
                receiptEmail: "robin+ios@crossmint.com"
            ),
            recipient: Recipient(walletAddress: "EbXL4e6XgbcC7s33cD5EZtyn5nixRDsieBjPQB7zf448"),
            apiKey: "your_crossmint_client_api_key",
            amount: "1",
            appearance: Appearance(
                rules: AppearanceRules(
                    destinationInput: DestinationInputRule(display: "hidden"),
                    receiptEmailInput: ReceiptEmailInputRule(display: "hidden"),
                )
            )
        )
    }
}

#Preview {
    ContentView()
}

