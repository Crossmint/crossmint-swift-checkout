//
//  Payment.swift
//  crossmint-ios-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import Foundation

// MARK: - Crypto Payment

struct CryptoPayment {
    let enabled: Bool
    let defaultChain: String?
    let defaultCurrency: String?
    
    init(
        enabled: Bool,
        defaultChain: String? = nil,
        defaultCurrency: String? = nil
    ) {
        self.enabled = enabled
        self.defaultChain = defaultChain
        self.defaultCurrency = defaultCurrency
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["enabled": enabled]
        if let chain = defaultChain { dict["defaultChain"] = chain }
        if let currency = defaultCurrency { dict["defaultCurrency"] = currency }
        return dict
    }
}

// MARK: - Fiat Payment

struct AllowedMethods {
    let googlePay: Bool?
    let applePay: Bool?
    let card: Bool?
    
    init(
        googlePay: Bool? = true,
        applePay: Bool? = true,
        card: Bool? = true
    ) {
        self.googlePay = googlePay
        self.applePay = applePay
        self.card = card
    }
    
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
    let defaultCurrency: String?
    let allowedMethods: AllowedMethods?
    
    init(
        enabled: Bool,
        defaultCurrency: String? = nil,
        allowedMethods: AllowedMethods? = nil
    ) {
        self.enabled = enabled
        self.defaultCurrency = defaultCurrency
        self.allowedMethods = allowedMethods
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["enabled": enabled]
        if let currency = defaultCurrency { dict["defaultCurrency"] = currency }
        if let methods = allowedMethods {
            dict["allowedMethods"] = methods.toDictionary()
        }
        return dict
    }
}

// MARK: - Payment

struct Payment {
    let crypto: CryptoPayment
    let fiat: FiatPayment
    let receiptEmail: String?
    let defaultMethod: String? // "fiat" or "crypto"
    
    init(
        crypto: CryptoPayment,
        fiat: FiatPayment,
        receiptEmail: String? = nil,
        defaultMethod: String? = nil
    ) {
        self.crypto = crypto
        self.fiat = fiat
        self.receiptEmail = receiptEmail
        self.defaultMethod = defaultMethod
    }
    
    func toWebviewDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "crypto": crypto.toDictionary(),
            "fiat": fiat.toDictionary()
        ]
        if let email = receiptEmail { dict["receiptEmail"] = email }
        if let method = defaultMethod { dict["defaultMethod"] = method }
        return dict
    }
    
    func toAPIDictionary() -> [String: Any] {
        var dict: [String: Any] = ["method": "checkoutcom-flow"]
        if let email = receiptEmail { dict["receiptEmail"] = email }
        return dict
    }
}

