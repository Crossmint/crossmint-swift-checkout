//
//  CrossmintAPI.swift
//  crossmint-ios-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import Foundation

class CrossmintAPI {
    
    private static let sdkMetadata = ["name": "@crossmint/client-sdk-react-ui", "version": "2.6.3"]
    
    // MARK: - Create Order
    
    static func createOrder(config: CrossmintCheckoutConfig, amount: String) async throws -> (clientSecret: String, orderId: String) {
        let ordersBaseUrl = config.environment == "production"
            ? "https://www.crossmint.com/api/2022-06-09/orders"
            : "https://staging.crossmint.com/api/2022-06-09/orders"
        
        var lineItemsDict = config.lineItems.toDictionary()
        if var execParams = lineItemsDict["executionParameters"] as? [String: String] {
            execParams["amount"] = amount
            lineItemsDict["executionParameters"] = execParams
        }
        
        let orderRequest: [String: Any] = [
            "recipient": config.recipient.toDictionary(),
            "lineItems": lineItemsDict,
            "payment": config.payment.toAPIDictionary()
        ]
        
        guard let url = URL(string: ordersBaseUrl) else {
            throw NSError(domain: "Invalid URL", code: 0)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(config.apiKey, forHTTPHeaderField: "X-API-KEY")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: orderRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Order API Status: \(httpResponse.statusCode)")
        }
        
        guard let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "Invalid response format", code: 0)
        }
        
        guard let clientSecret = jsonResponse["clientSecret"] as? String else {
            throw NSError(domain: "Missing clientSecret in response", code: 0)
        }
        
        guard let order = jsonResponse["order"] as? [String: Any],
              let orderId = order["orderId"] as? String else {
            throw NSError(domain: "Missing orderId in response", code: 0)
        }
        
        return (clientSecret, orderId)
    }
    
    // MARK: - Generate Checkout URL
    
    static func generateCheckoutUrl(config: CrossmintCheckoutConfig, amount: String) async throws -> String {
        let (clientSecret, orderId) = try await createOrder(config: config, amount: amount)
        
        let checkoutBaseUrl = config.environment == "production"
            ? "https://www.crossmint.com/sdk/2024-03-05/embedded-checkout"
            : "https://staging.crossmint.com/sdk/2024-03-05/embedded-checkout"
        
        var lineItemsDict = config.lineItems.toDictionary()
        if var execParams = lineItemsDict["executionParameters"] as? [String: String] {
            execParams["amount"] = amount
            lineItemsDict["executionParameters"] = execParams
        }
        
        let url = "\(checkoutBaseUrl)?" + [
            "orderId=\(orderId)",
            "clientSecret=\(clientSecret)",
            "lineItems=\(try jsonToURLParam(lineItemsDict))",
            "payment=\(try jsonToURLParam(config.payment.toWebviewDictionary()))",
            "recipient=\(try jsonToURLParam(config.recipient.toDictionary()))",
            "sdkMetadata=\(try jsonToURLParam(sdkMetadata))"
        ].joined(separator: "&")
        
        print("Generated URL: \(url)")
        return url
    }
    
    // MARK: - Helpers
    
    private static func encodeQueryValue(_ value: String) -> String {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "+")
        return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
    }
    
    private static func jsonToURLParam(_ object: Any) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object, options: [.withoutEscapingSlashes])
        let json = String(data: data, encoding: .utf8)!
        return encodeQueryValue(json)
    }
}

