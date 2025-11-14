//
//  ContentView.swift
//  crossmint-ios-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import SwiftUI
import WebKit
import UIKit


let apiKey = "YOUR_API_KEY" // Replace with actual key
let environment = apiKey.starts(with: "ck_production") ? "production" : "staging"
let ordersBaseUrl = environment == "production"
    ? "https://www.crossmint.com/api/2022-06-09/orders"
    : "https://staging.crossmint.com/api/2022-06-09/orders"

// Default options
let defaultRecipient = ["walletAddress": "EbXL4e6XgbcC7s33cD5EZtyn5nixRDsieBjPQB7zf448"]
let defaultLineItems: [String: Any] = [
    "tokenLocator": "solana:7EivYFyNfgGj8xbUymR7J4LuxUHLKRzpLaERHLvi7Dgu",
    "executionParameters": [
        "mode": "exact-in",
        "amount": "1", // Will be overridden
        "maxSlippageBps": "500"
    ]
]
// Payment for API call (creating order)
let apiPayment: [String: Any] = [
    "method": "checkoutcom-flow",
    "receiptEmail": "robin+ios@crossmint.com"
]

// Payment for webview URL
let webviewPayment: [String: Any] = [
    "crypto": ["enabled": false],
    "fiat": ["enabled": true],
    "receiptEmail": "robin+ios@crossmint.com"
]
let sdkMetadata = ["name": "@crossmint/client-sdk-react-ui", "version": "2.6.3"]

// Function to create order via API
func createOrder(amount: String) async throws -> (String, String) {
    var lineItems = defaultLineItems
    if var execParams = lineItems["executionParameters"] as? [String: String] {
        execParams["amount"] = amount
        lineItems["executionParameters"] = execParams
    }
    
    let orderRequest: [String: Any] = [
        "recipient": defaultRecipient,
        "lineItems": lineItems,
        "payment": apiPayment
    ]
    
    guard let url = URL(string: ordersBaseUrl) else {
        throw NSError(domain: "Invalid URL", code: 0)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONSerialization.data(withJSONObject: orderRequest)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    // Debug: Print the raw response
    if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
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

// Helper to properly encode URL query values
func encodeQueryValue(_ value: String) -> String {
    var allowed = CharacterSet.urlQueryAllowed
    allowed.remove(charactersIn: "+") // Ensure + is encoded as %2B
    return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
}

// Helper to serialize JSON for URL parameters
func jsonToURLParam(_ object: Any) throws -> String {
    let data = try JSONSerialization.data(withJSONObject: object, options: [.withoutEscapingSlashes])
    let json = String(data: data, encoding: .utf8)!
    return encodeQueryValue(json)
}

// Function to generate checkout URL
func generateCheckoutUrl(amount: String) async throws -> String {
    let (clientSecret, orderId) = try await createOrder(amount: amount)
    
    // Update lineItems with the correct amount
    var lineItems = defaultLineItems
    if var execParams = lineItems["executionParameters"] as? [String: String] {
        execParams["amount"] = amount
        lineItems["executionParameters"] = execParams
    }
    
    let baseUrl = environment == "production"
        ? "https://www.crossmint.com/sdk/2024-03-05/embedded-checkout"
        : "https://staging.crossmint.com/sdk/2024-03-05/embedded-checkout"
    
    let url = "\(baseUrl)?" + [
        "orderId=\(orderId)",
        "clientSecret=\(clientSecret)",
        "lineItems=\(try jsonToURLParam(lineItems))",
        "payment=\(try jsonToURLParam(webviewPayment))",
        "recipient=\(try jsonToURLParam(defaultRecipient))",
        "sdkMetadata=\(try jsonToURLParam(sdkMetadata))"
    ].joined(separator: "&")
    
    print("Generated URL: \(url)")
    return url
}

// Custom WebView
struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.applicationNameForUserAgent = "iOSPOCApp" // Optional
        
        // Custom user agent mimicking Safari
        let osVersion = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
        let safariVersion = String(Int(Double(UIDevice.current.systemVersion) ?? 0) / 2)
        let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS \(osVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(safariVersion).0 Mobile/15E148 Safari/604.1"
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = userAgent
        webView.scrollView.isScrollEnabled = false // scrollEnabled=false
        
        // Allow all navigations for originWhitelist=["*"]
        context.coordinator.webView = webView
        webView.navigationDelegate = context.coordinator
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var webView: WKWebView?
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Allow all for *
            decisionHandler(.allow)
        }
    }
}

// Main View
struct ContentView: View {
    @State private var currentView: String = "amount" // "amount" or "webview"
    @State private var inputAmount: String = "1"
    @State private var checkoutUrl: String = ""
    @State private var isLoading = false
    
    var body: some View {
        if currentView == "amount" {
            VStack(spacing: 20) {
                Text("How much do you want to pay?")
                    .font(.headline)
                    .padding()
                
                HStack {
                    Text("$")
                        .font(.system(size: 46, weight: .bold))
                    Text(inputAmount)
                        .font(.system(size: 46, weight: .bold))
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green, lineWidth: 1))
                
                // Quick amounts
                HStack(spacing: 10) {
                    quickAmountButton(amount: 25)
                    quickAmountButton(amount: 50)
                    quickAmountButton(amount: 75)
                    quickAmountButton(amount: 100)
                }
                
                // Keypad
                VStack(spacing: 20) {
                    keypadRow(numbers: ["1", "2", "3"])
                    keypadRow(numbers: ["4", "5", "6"])
                    keypadRow(numbers: ["7", "8", "9"])
                    HStack(spacing: 20) {
                        keypadButton(num: "0")
                        Button(action: deletePress) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 24))
                        }
                    }
                }
                
                Button("Continue") {
                    Task {
                        isLoading = true
                        do {
                            checkoutUrl = try await generateCheckoutUrl(amount: inputAmount)
                            print("Generated Checkout URL: \(checkoutUrl)")
                            currentView = "webview"
                        } catch {
                            print("Error: \(error)")
                            // Handle error (e.g., show alert)
                        }
                        isLoading = false
                    }
                }
                .disabled(inputAmount.isEmpty || inputAmount == "0" || isLoading)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        } else {
            WebView(url: checkoutUrl)
        }
    }
    
    func quickAmountButton(amount: Int) -> some View {
        Button("$\(amount)") {
            inputAmount = String(amount)
        }
        .padding(8)
        .background(Color.green.opacity(0.2))
        .cornerRadius(20)
    }
    
    func keypadRow(numbers: [String]) -> some View {
        HStack(spacing: 20) {
            ForEach(numbers, id: \.self) { num in
                keypadButton(num: num)
            }
        }
    }
    
    func keypadButton(num: String) -> some View {
        Button(action: { numberPress(num: num) }) {
            Text(num)
                .font(.system(size: 24, weight: .medium))
        }
    }
    
    func numberPress(num: String) {
        if inputAmount == "0" {
            inputAmount = num
        } else {
            inputAmount += num
        }
    }
    
    func deletePress() {
        if !inputAmount.isEmpty {
            inputAmount.removeLast()
            if inputAmount.isEmpty {
                inputAmount = "0"
            }
        }
    }
}

#Preview {
    ContentView()
}
