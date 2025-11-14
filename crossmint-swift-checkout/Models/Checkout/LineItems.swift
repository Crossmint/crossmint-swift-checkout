//
//  LineItems.swift
//  crossmint-swift-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import Foundation

struct LineItems {
    let tokenLocator: String
    let executionParameters: [String: Any]?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["tokenLocator": tokenLocator]
        if let executionParameters = executionParameters {
            dict["executionParameters"] = executionParameters
        }
        return dict
    }
}

