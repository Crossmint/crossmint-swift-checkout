//
//  Recipient.swift
//  crossmint-swift-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import Foundation

struct Recipient {
    let walletAddress: String?
    let email: String?
    
    init(
        walletAddress: String? = nil,
        email: String? = nil
    ) {
        self.walletAddress = walletAddress
        self.email = email
    }
    
    func toDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        if let wallet = walletAddress { dict["walletAddress"] = wallet }
        if let email = email { dict["email"] = email }
        return dict
    }
}

