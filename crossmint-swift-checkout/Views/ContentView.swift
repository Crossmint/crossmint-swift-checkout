//
//  ContentView.swift
//  crossmint-swift-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import SwiftUI
import Checkout

struct ContentView: View {
    var body: some View {
        CrossmintEmbeddedCheckout(
            orderId: "your-order-id",
            clientSecret: "your-client-secret",
            payment: CheckoutPayment(
                crypto: CheckoutCryptoPayment(enabled: false),
                fiat: CheckoutFiatPayment(
                    enabled: true,
                    allowedMethods: CheckoutAllowedMethods(
                        googlePay: false,
                        applePay: true,
                        card: false
                    )
                ),
                receiptEmail: "robin+ios@crossmint.com"
            ),
            appearance: CheckoutAppearance(
                rules: CheckoutAppearanceRules(
                    destinationInput: CheckoutDestinationInputRule(display: "hidden"),
                    receiptEmailInput: CheckoutReceiptEmailInputRule(display: "hidden")
                )
            ),
            environment: .staging
        )
    }
}

#Preview {
    ContentView()
}
