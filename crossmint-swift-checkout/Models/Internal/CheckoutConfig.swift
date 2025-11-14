//
//  CheckoutConfig.swift
//  crossmint-swift-checkout
//
//  Internal configuration model for API communication
//  Created by Robin Curbelo on 11/13/25.
//

import Foundation

struct CheckoutConfig {
    let lineItems: LineItems
    let payment: Payment
    let recipient: Recipient
    let apiKey: String
    
    var environment: String {
        apiKey.starts(with: "ck_production") ? "production" : "staging"
    }
}

