# Crossmint Swift Checkout Example

Example iOS app demonstrating how to implement the `CrossmintEmbeddedCheckout` component **without the Crossmint SDK**. This project contains a standalone implementation that you can reference or copy into your own app.

## Dependencies

This example includes the checkout implementation directly (no SDK required). The only frameworks used are:

- `SwiftUI` - UI framework
- `WebKit` - For the checkout WebView

No external packages or dependencies needed.

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
        )
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

### 3. Track Order Status (Server-side)

Monitor the order as it progresses through payment and delivery. Use webhooks for real-time updates or polling as a fallback.

#### Option A: Webhooks (Recommended)

Set up webhooks to receive real-time updates as the order progresses through payment and delivery.

**Setup:**

1. Create a `POST` endpoint on your server (e.g., `/webhooks/crossmint`)
2. Configure webhook in [Crossmint Console](https://www.crossmint.com/console/webhooks)
3. Save the signing secret for verification

**Key Events:**

- `orders.quote.created` - Order created
- `orders.payment.succeeded` - Payment confirmed
- `orders.delivery.completed` - Tokens delivered (includes `txId`)
- `orders.payment.failed` - Payment failed

See full documentation: [Webhooks Guide](https://docs.crossmint.com/introduction/platform/webhooks/overview)

#### Option B: Polling (Fallback)

Poll the order status if webhooks aren't feasible. Be mindful of rate limits.

```bash
curl --location 'https://www.crossmint.com/api/2022-06-09/orders/{orderId}' \
--header 'x-api-key: YOUR_API_KEY'
```

See full documentation: [Get Order API](https://docs.crossmint.com/api-reference/headless/get-order)

## Project Structure

```
crossmint-swift-checkout/
├── Checkout/
│   ├── CrossmintEmbeddedCheckout.swift  # Main checkout view
│   ├── CheckoutWebView.swift            # WebView component
│   ├── CheckoutError.swift              # Error types
│   └── Models/
│       ├── CheckoutAppearance.swift     # UI customization
│       ├── CheckoutPayment.swift        # Payment config
│       ├── CheckoutLineItems.swift      # Line items (WIP)
│       └── CheckoutRecipient.swift      # Recipient (WIP)
└── Views/
    └── ContentView.swift                # Example usage
```

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

## Example

See `ContentView.swift` for a complete working example.

## Resources

- [Crossmint Documentation](https://docs.crossmint.com)
- [Create Order API](https://docs.crossmint.com/api-reference/headless/create-order)
- [Get Order API](https://docs.crossmint.com/api-reference/headless/get-order)
