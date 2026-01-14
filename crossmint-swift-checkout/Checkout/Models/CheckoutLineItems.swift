//
//  CheckoutLineItems.swift
//  crossmint-swift-checkout
//
//  Line items configuration for embedded checkout
//

import Foundation

public struct CheckoutLineItems: Codable {
    public let tokenLocator: String?
    public let collectionLocator: String?

    public init(
        tokenLocator: String? = nil,
        collectionLocator: String? = nil
    ) {
        self.tokenLocator = tokenLocator
        self.collectionLocator = collectionLocator
    }
}
