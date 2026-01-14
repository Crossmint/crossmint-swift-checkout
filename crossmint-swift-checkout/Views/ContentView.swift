//
//  ContentView.swift
//  crossmint-swift-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

struct ContentView: View {
    var body: some View {
        CrossmintEmbeddedCheckout(
            orderId: "bc360a41-b7c1-4794-9829-f374185a939f",
            clientSecret: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmRlcklkZW50aWZpZXIiOiJiYzM2MGE0MS1iN2MxLTQ3OTQtOTgyOS1mMzc0MTg1YTkzOWYiLCJjb2xsZWN0aW9uSWQiOiI0MTc3MzNiZi03YWY3LTQ1ZmUtYWQwZi0wYjVkMTcwMDdlMDciLCJpYXQiOjE3Njg0MTk5ODAsImV4cCI6MTc2ODUwNjM4MH0.g-Ha-2eGQNO8x5v6Ocdbde8pCuTv3vQfK8yZMcVYjm8",
            payment: CheckoutPayment(
                crypto: CheckoutCryptoPayment(enabled: false),
                fiat: CheckoutFiatPayment(
                    enabled: true,
                    allowedMethods: CheckoutAllowedMethods(
                        googlePay: false,
                        applePay: true,
                        card: false
                    )
                )
            ),
            appearance: CheckoutAppearance(
                variables: CheckoutAppearanceVariables(
                    colors: CheckoutColorStyle(backgroundPrimary: "#1a1a1a")
                ),
                rules: CheckoutAppearanceRules(
                    destinationInput: CheckoutDestinationInputRule(display: "hidden"),
                    receiptEmailInput: CheckoutReceiptEmailInputRule(display: "hidden")
                )
            ),
            environment: .staging
        )
        .background(Color(hex: "#1a1a1a"))
    }
}
