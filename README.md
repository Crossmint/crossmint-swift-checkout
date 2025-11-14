# Crossmint iOS Checkout POC

A clean, well-organized iOS app demonstrating Crossmint's embedded checkout integration using a React-like component pattern.

## Structure

```
crossmint-ios-checkout/
├── Models.swift                     # Type-safe models for all checkout parameters
├── CrossmintAPI.swift              # API service layer (order creation, URL generation)
├── CrossmintWebView.swift          # WebKit webview component
├── CrossmintEmbeddedCheckout.swift # Main checkout component (React-like)
├── ContentView.swift               # UI entry point
└── crossmint_ios_checkoutApp.swift # App entry point
```

## Usage

Simply configure the `CrossmintEmbeddedCheckout` component in `ContentView.swift` like a React component:

```swift
CrossmintEmbeddedCheckout(
    lineItems: LineItems(
        tokenLocator: "solana:7EivYFyNfgGj8xbUymR7J4LuxUHLKRzpLaERHLvi7Dgu",
        executionParameters: ExecutionParameters(
            mode: "exact-in",
            amount: "1",
            maxSlippageBps: "500"
        )
    ),
    payment: Payment(
        crypto: CryptoPayment(
            enabled: false,
            defaultChain: nil,
            defaultCurrency: nil
        ),
        fiat: FiatPayment(
            enabled: true,
            allowedMethods: nil
        ),
        receiptEmail: "receipt@crossmint.com"
    ),
    recipient: Recipient(
        walletAddress: "EbXL4e6XgbcC7s33cD5EZtyn5nixRDsieBjPQB7zf448"
    ),
    apiKey: "ck_staging_...",
    amount: "1"
)
```

## Architecture

### Models (`Models.swift`)
Type-safe Swift structs representing all checkout configuration:
- `LineItems` & `ExecutionParameters`
- `Payment`, `CryptoPayment`, `FiatPayment`, `AllowedMethods`
- `Recipient`
- `CrossmintCheckoutConfig`

### API Layer (`CrossmintAPI.swift`)
Handles all backend communication:
- `createOrder()` - Creates order via Crossmint API
- `generateCheckoutUrl()` - Builds properly encoded checkout URL
- Helper methods for URL encoding (handles special chars like `+`)

### Component (`CrossmintEmbeddedCheckout.swift`)
React-like SwiftUI component:
- Takes typed parameters (like React props)
- Manages its own state (loading, error, success)
- Handles checkout lifecycle internally

### WebView (`CrossmintWebView.swift`)
Renders the checkout experience:
- Configured with Safari-like user agent
- Handles navigation policies
- Optimized for mobile display

## How It Works

1. Configure `CrossmintEmbeddedCheckout` with your parameters
2. Component creates order via API (gets `orderId` & `clientSecret`)
3. Generates embedded checkout URL with proper encoding
4. Displays checkout webview

All parameters are type-safe, properly encoded, and validated at compile time.

