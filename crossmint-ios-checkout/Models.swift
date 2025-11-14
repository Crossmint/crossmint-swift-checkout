//
//  Models.swift
//  crossmint-ios-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import Foundation

// MARK: - Line Items

struct ExecutionParameters {
    let mode: String
    let amount: String
    let maxSlippageBps: String
    
    func toDictionary() -> [String: String] {
        [
            "mode": mode,
            "amount": amount,
            "maxSlippageBps": maxSlippageBps
        ]
    }
}

struct LineItems {
    let tokenLocator: String
    let executionParameters: ExecutionParameters
    
    func toDictionary() -> [String: Any] {
        [
            "tokenLocator": tokenLocator,
            "executionParameters": executionParameters.toDictionary()
        ]
    }
}

// MARK: - Payment

struct CryptoPayment {
    let enabled: Bool
    let defaultChain: String?
    let defaultCurrency: String?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["enabled": enabled]
        if let chain = defaultChain { dict["defaultChain"] = chain }
        if let currency = defaultCurrency { dict["defaultCurrency"] = currency }
        return dict
    }
}

struct AllowedMethods {
    let googlePay: Bool?
    let applePay: Bool?
    let card: Bool?
    
    func toDictionary() -> [String: Bool] {
        var dict: [String: Bool] = [:]
        if let googlePay = googlePay { dict["googlePay"] = googlePay }
        if let applePay = applePay { dict["applePay"] = applePay }
        if let card = card { dict["card"] = card }
        return dict
    }
}

struct FiatPayment {
    let enabled: Bool
    let allowedMethods: AllowedMethods?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["enabled": enabled]
        if let methods = allowedMethods {
            dict["allowedMethods"] = methods.toDictionary()
        }
        return dict
    }
}

struct Payment {
    let crypto: CryptoPayment
    let fiat: FiatPayment
    let receiptEmail: String
    
    func toWebviewDictionary() -> [String: Any] {
        [
            "crypto": crypto.toDictionary(),
            "fiat": fiat.toDictionary(),
            "receiptEmail": receiptEmail
        ]
    }
    
    func toAPIDictionary() -> [String: Any] {
        [
            "method": "checkoutcom-flow",
            "receiptEmail": receiptEmail
        ]
    }
}

// MARK: - Recipient

struct Recipient {
    let walletAddress: String
    
    func toDictionary() -> [String: String] {
        ["walletAddress": walletAddress]
    }
}

// MARK: - Checkout Configuration

struct CrossmintCheckoutConfig {
    let lineItems: LineItems
    let payment: Payment
    let recipient: Recipient
    let apiKey: String
    
    var environment: String {
        apiKey.starts(with: "ck_production") ? "production" : "staging"
    }
}

