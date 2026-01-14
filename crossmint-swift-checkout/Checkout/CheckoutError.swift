//
//  CheckoutError.swift
//  crossmint-swift-checkout
//
//  Errors for the Checkout module
//

import Foundation

public enum CheckoutError: Error, LocalizedError {
    case notImplemented(String)
    case invalidConfiguration(String)

    public var errorDescription: String? {
        switch self {
        case .notImplemented(let message):
            return message
        case .invalidConfiguration(let message):
            return message
        }
    }
}
