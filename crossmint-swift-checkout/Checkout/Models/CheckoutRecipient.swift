//
//  CheckoutRecipient.swift
//  crossmint-swift-checkout
//
//  Recipient configuration for embedded checkout
//

import Foundation

public struct CheckoutRecipient: Codable {
    public let walletAddress: String?
    public let email: String?

    public init(
        walletAddress: String? = nil,
        email: String? = nil
    ) {
        self.walletAddress = walletAddress
        self.email = email
    }
}
