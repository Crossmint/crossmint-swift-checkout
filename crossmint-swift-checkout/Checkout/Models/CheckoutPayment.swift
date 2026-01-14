//
//  CheckoutPayment.swift
//  crossmint-swift-checkout
//
//  Payment configuration for embedded checkout
//

import Foundation

// MARK: - Crypto Payment

public struct CheckoutCryptoPayment: Codable {
    public let enabled: Bool
    public let defaultChain: String?
    public let defaultCurrency: String?

    public init(
        enabled: Bool,
        defaultChain: String? = nil,
        defaultCurrency: String? = nil
    ) {
        self.enabled = enabled
        self.defaultChain = defaultChain
        self.defaultCurrency = defaultCurrency
    }
}

// MARK: - Fiat Payment

public struct CheckoutAllowedMethods: Codable {
    public let googlePay: Bool?
    public let applePay: Bool?
    public let card: Bool?

    public init(
        googlePay: Bool? = true,
        applePay: Bool? = true,
        card: Bool? = true
    ) {
        self.googlePay = googlePay
        self.applePay = applePay
        self.card = card
    }
}

public struct CheckoutFiatPayment: Codable {
    public let enabled: Bool
    public let defaultCurrency: String?
    public let allowedMethods: CheckoutAllowedMethods?

    public init(
        enabled: Bool,
        defaultCurrency: String? = nil,
        allowedMethods: CheckoutAllowedMethods? = nil
    ) {
        self.enabled = enabled
        self.defaultCurrency = defaultCurrency
        self.allowedMethods = allowedMethods
    }
}

// MARK: - Payment

public struct CheckoutPayment: Codable {
    public enum Method: String, Codable {
        case crypto
        case fiat
    }

    public let crypto: CheckoutCryptoPayment
    public let fiat: CheckoutFiatPayment
    public let receiptEmail: String?
    public let defaultMethod: Method?

    public init(
        crypto: CheckoutCryptoPayment,
        fiat: CheckoutFiatPayment,
        receiptEmail: String? = nil,
        defaultMethod: Method? = nil
    ) {
        self.crypto = crypto
        self.fiat = fiat
        self.receiptEmail = receiptEmail
        self.defaultMethod = defaultMethod
    }
}
