# Crossmint Swift Checkout Example

Example iOS app demonstrating the `CrossmintEmbeddedCheckout` component from the Crossmint SDK.

## Installation

Add the Crossmint SDK to your project via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/Crossmint/crossmint-swift-sdk", branch: "main")
]
```

## Integration Flow

### 1. Create Order (Server-side)

First, create an order on your server using the Crossmint API:

**Important:** Order creation must be done server-side to keep your API key secure.

```bash
# Production
curl --location 'https://www.crossmint.com/api/2022-06-09/orders' \
--header 'x-api-key: YOUR_API_KEY' \
--header 'Content-Type: application/json' \
--data-raw '{
    "recipient": {
        "walletAddress": "WALLET_ADDRESS"
    },
    "payment": {
        "receiptEmail": "user@example.com",
        "method": "card"
    },
    "lineItems": {
        "tokenLocator": "chain:token",
        "executionParameters": {
            "mode": "exact-in",
            "amount": "1"
        }
    }
}'

# Staging
curl --location 'https://staging.crossmint.com/api/2022-06-09/orders' \
--header 'x-api-key: YOUR_API_KEY' \
--header 'Content-Type: application/json' \
--data-raw '{...}'
```

See full documentation: [Create Order API](https://docs.crossmint.com/api-reference/headless/create-order) and [Payment Methods](https://docs.crossmint.com/payments/introduction)

The response will include:

- `orderId` - Unique identifier for the order
- `clientSecret` - Token scoped to this order for client-side operations

### 2. Use the Component (Client-side)

Pass the `orderId`, `clientSecret`, and optional configuration to the component:

```swift
import SwiftUI
import Checkout

CrossmintEmbeddedCheckout(
    orderId: "your-order-id",
    clientSecret: "your-client-secret",
    payment: CheckoutPayment(
        crypto: CheckoutCryptoPayment(enabled: false),
        fiat: CheckoutFiatPayment(
            enabled: true,
            allowedMethods: CheckoutAllowedMethods(
                googlePay: false,
                applePay: true,
                card: false
            )
        ),
        receiptEmail: "user@example.com"
    ),
    appearance: CheckoutAppearance(
        rules: CheckoutAppearanceRules(
            destinationInput: CheckoutDestinationInputRule(display: "hidden"),
            receiptEmailInput: CheckoutReceiptEmailInputRule(display: "hidden")
        )
    ),
    environment: .production  // or .staging
)
```

### 3. Poll Order Status (Server-side)

Monitor the order status on your server:

```bash
# Production
curl --location 'https://www.crossmint.com/api/2022-06-09/orders/{orderId}' \
--header 'x-api-key: YOUR_API_KEY'

# Staging
curl --location 'https://staging.crossmint.com/api/2022-06-09/orders/{orderId}' \
--header 'x-api-key: YOUR_API_KEY'
```

See full documentation: [Get Order API](https://docs.crossmint.com/api-reference/headless/get-order)

## Available Properties

### Currently Supported

- `orderId` - Order identifier from create order API
- `clientSecret` - Client secret from create order API
- `payment` - Payment method configuration
- `appearance` - UI customization options
- `environment` - `.staging` or `.production`

### Work in Progress

The following properties are defined but not yet implemented:

- `lineItems` - Line items configuration
- `recipient` - Recipient information
- `apiKey` - Crossmint Client API Key

**Note:** More fields will be added in future releases.

## Example

See `ContentView.swift` for a complete working example.

## Resources

- [Crossmint Documentation](https://docs.crossmint.com)
- [Create Order API](https://docs.crossmint.com/api-reference/headless/create-order)
- [Get Order API](https://docs.crossmint.com/api-reference/headless/get-order)
