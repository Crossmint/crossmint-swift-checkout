# Crossmint Swift Checkout

Swift integration for Crossmint's embedded checkout.

> **Note:** This is a reference implementation. The `CrossmintEmbeddedCheckout` component will be integrated into the official Crossmint SDK. The API surface (properties, methods, and components) will remain stable, ensuring no breaking changes when migrating to the official SDK.


## Project Structure

```bash
crossmint-swift-checkout/
├── Models/
│   ├── Checkout/
│   │   ├── LineItems.swift
│   │   ├── Payment.swift
│   │   ├── Recipient.swift
│   │   └── Appearance.swift
│   └── Internal/
│       └── CheckoutConfig.swift
├── Services/
│   └── CrossmintAPI.swift
├── Views/
│   ├── Components/
│   │   ├── CrossmintEmbeddedCheckout.swift
│   │   └── CrossmintWebView.swift
│   └── ContentView.swift
└── crossmint_swift_checkout.swift
```

## Usage

Configure the `CrossmintEmbeddedCheckout` component with your checkout parameters:

### Example: Apple Pay Only

```swift
CrossmintEmbeddedCheckout(
    lineItems: LineItems(
        tokenLocator: "solana:7EivYFyNfgGj8xbUymR7J4LuxUHLKRzpLaERHLvi7Dgu",
        executionParameters: [
            "mode": "exact-in",
            "amount": "1",
            "maxSlippageBps": "500"
        ]
    ),
    payment: Payment(
        crypto: CryptoPayment(enabled: false),
        fiat: FiatPayment(
            enabled: true,
            allowedMethods: AllowedMethods(
                googlePay: false, // Disable Google Pay
                applePay: true, // Enable Apple Pay
                card: false, // Disable card payments
            )
        ),
        receiptEmail: "your@email.com"
    ),
    recipient: Recipient(walletAddress: "EbXL4e6XgbcC7s33cD5EZtyn5nixRDsieBjPQB7zf448"),
    apiKey: "your_crossmint_client_api_key",
    amount: "1",
    appearance: Appearance(
        rules: AppearanceRules(
            destinationInput: DestinationInputRule(display: "hidden"),
            receiptEmailInput: ReceiptEmailInputRule(display: "hidden")
        )
    )
)
```

### Example: Custom Button Styling

```swift
appearance: Appearance(
    rules: AppearanceRules(
        primaryButton: PrimaryButtonRule(
            borderRadius: "8px",
            font: FontStyle(
                family: "Arial",
                size: "16px",
                weight: "bold"
            ),
            colors: ColorStyle(
                text: "#FFFFFF",
                background: "#000000",
                border: nil,
                boxShadow: nil,
                placeholder: nil
            ),
            hover: StateStyle(
                colors: ColorStyle(
                    text: nil,
                    background: "#3C4043",
                    border: nil,
                    boxShadow: nil,
                    placeholder: nil
                )
            ),
            disabled: nil
        )
    )
)
```

## API Reference

### Models

#### LineItems

Configuration for the items being purchased.

- `tokenLocator`: Token identifier (e.g., `"solana:7EivYFyNfgGj8xbUymR7J4LuxUHLKRzpLaERHLvi7Dgu"`)
- `executionParameters`: Optional dictionary for execution configuration

#### Payment

Payment method configuration.

- `crypto`: Cryptocurrency payment settings
  - `enabled`: Enable/disable crypto payments
  - `defaultChain`: Default blockchain (optional)
  - `defaultCurrency`: Default currency (optional)
- `fiat`: Fiat payment settings
  - `enabled`: Enable/disable fiat payments
  - `defaultCurrency`: Default fiat currency (optional)
  - `allowedMethods`: Configure payment methods (optional)
    - `googlePay`: Enable Google Pay
    - `applePay`: Enable Apple Pay
    - `card`: Enable card payments
- `receiptEmail`: Email for receipt (optional)
- `defaultMethod`: Default payment tab - `"fiat"` or `"crypto"` (optional)

#### Recipient

Delivery destination for purchased items.

- `walletAddress`: Blockchain wallet address (optional)
- `email`: Email address (optional)

Note: Provide either `walletAddress` or `email`.

#### Appearance (Optional)

Customize the checkout UI appearance. Only applies to the webview display.

- `rules`: Appearance rules for UI elements
  - `destinationInput`: Control destination input visibility
  - `receiptEmailInput`: Control email input visibility
  - `label`: Label styling
  - `input`: Input field styling
  - `tab`: Tab styling
  - `primaryButton`: Primary button styling

Each rule supports:

- `colors`: Color customization (text, background, border, etc.)
- `font`: Typography (family, size, weight)
- State-specific styling (hover, focus, selected, disabled)

### CrossmintEmbeddedCheckout

Main checkout component. Parameters:

- `lineItems`: LineItems configuration
- `payment`: Payment configuration
- `recipient`: Recipient information
- `apiKey`: Crossmint API key
- `amount`: Purchase amount as string
- `appearance`: Optional UI customization

## Implementation Details

The component handles the complete checkout flow:

1. Creates an order via the Crossmint API
2. Generates a properly encoded checkout URL
3. Displays the checkout experience in a webview
4. Manages loading and error states
