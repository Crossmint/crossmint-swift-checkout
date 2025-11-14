//
//  ContentView.swift
//  crossmint-ios-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CrossmintEmbeddedCheckout(
            lineItems: LineItems(
                tokenLocator: "solana:7EivYFyNfgGj8xbUymR7J4LuxUHLKRzpLaERHLvi7Dgu",
                executionParameters: ExecutionParameters(
                    mode: "exact-in",
                    amount: "1",
                    maxSlippageBps: "500"
                )
            ),
            payment: Payment(
                crypto: CryptoPayment(
                    enabled: false,
                    defaultChain: nil,
                    defaultCurrency: nil
                ),
                fiat: FiatPayment(
                    enabled: true,
                    allowedMethods: nil
                ),
                receiptEmail: "robin+ios@crossmint.com"
            ),
            recipient: Recipient(
                walletAddress: "EbXL4e6XgbcC7s33cD5EZtyn5nixRDsieBjPQB7zf448"
            ),
            apiKey: "YOUR_CLIENT_API_KEY",
            amount: "1"
        )
    }
}

#Preview {
    ContentView()
}
