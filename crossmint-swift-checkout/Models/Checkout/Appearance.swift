//
//  Appearance.swift
//  crossmint-swift-checkout
//
//  Created by Robin Curbelo on 11/13/25.
//

import Foundation

// MARK: - Base Styles

struct FontStyle {
    let family: String?
    let size: String?
    let weight: String?
    
    func toDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        if let family = family { dict["family"] = family }
        if let size = size { dict["size"] = size }
        if let weight = weight { dict["weight"] = weight }
        return dict
    }
}

struct ColorStyle {
    let text: String?
    let background: String?
    let border: String?
    let boxShadow: String?
    let placeholder: String?
    
    func toDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        if let text = text { dict["text"] = text }
        if let background = background { dict["background"] = background }
        if let border = border { dict["border"] = border }
        if let boxShadow = boxShadow { dict["boxShadow"] = boxShadow }
        if let placeholder = placeholder { dict["placeholder"] = placeholder }
        return dict
    }
}

struct StateStyle {
    let colors: ColorStyle?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let colors = colors, !colors.toDictionary().isEmpty {
            dict["colors"] = colors.toDictionary()
        }
        return dict
    }
}

// MARK: - UI Element Rules

struct DestinationInputRule {
    let display: String? // "hidden"
    
    func toDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        if let display = display { dict["display"] = display }
        return dict
    }
}

struct ReceiptEmailInputRule {
    let display: String? // "hidden"
    
    func toDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        if let display = display { dict["display"] = display }
        return dict
    }
}

struct LabelRule {
    let font: FontStyle?
    let colors: ColorStyle?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let font = font, !font.toDictionary().isEmpty {
            dict["font"] = font.toDictionary()
        }
        if let colors = colors, !colors.toDictionary().isEmpty {
            dict["colors"] = colors.toDictionary()
        }
        return dict
    }
}

struct InputRule {
    let borderRadius: String?
    let font: FontStyle?
    let colors: ColorStyle?
    let hover: StateStyle?
    let focus: StateStyle?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let borderRadius = borderRadius { dict["borderRadius"] = borderRadius }
        if let font = font, !font.toDictionary().isEmpty {
            dict["font"] = font.toDictionary()
        }
        if let colors = colors, !colors.toDictionary().isEmpty {
            dict["colors"] = colors.toDictionary()
        }
        if let hover = hover, !hover.toDictionary().isEmpty {
            dict["hover"] = hover.toDictionary()
        }
        if let focus = focus, !focus.toDictionary().isEmpty {
            dict["focus"] = focus.toDictionary()
        }
        return dict
    }
}

struct TabRule {
    let borderRadius: String?
    let font: FontStyle?
    let colors: ColorStyle?
    let hover: StateStyle?
    let selected: StateStyle?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let borderRadius = borderRadius { dict["borderRadius"] = borderRadius }
        if let font = font, !font.toDictionary().isEmpty {
            dict["font"] = font.toDictionary()
        }
        if let colors = colors, !colors.toDictionary().isEmpty {
            dict["colors"] = colors.toDictionary()
        }
        if let hover = hover, !hover.toDictionary().isEmpty {
            dict["hover"] = hover.toDictionary()
        }
        if let selected = selected, !selected.toDictionary().isEmpty {
            dict["selected"] = selected.toDictionary()
        }
        return dict
    }
}

struct PrimaryButtonRule {
    let borderRadius: String?
    let font: FontStyle?
    let colors: ColorStyle?
    let hover: StateStyle?
    let disabled: StateStyle?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let borderRadius = borderRadius { dict["borderRadius"] = borderRadius }
        if let font = font, !font.toDictionary().isEmpty {
            dict["font"] = font.toDictionary()
        }
        if let colors = colors, !colors.toDictionary().isEmpty {
            dict["colors"] = colors.toDictionary()
        }
        if let hover = hover, !hover.toDictionary().isEmpty {
            dict["hover"] = hover.toDictionary()
        }
        if let disabled = disabled, !disabled.toDictionary().isEmpty {
            dict["disabled"] = disabled.toDictionary()
        }
        return dict
    }
}

// MARK: - Appearance Rules

struct AppearanceRules {
    let destinationInput: DestinationInputRule?
    let receiptEmailInput: ReceiptEmailInputRule?
    let label: LabelRule?
    let input: InputRule?
    let tab: TabRule?
    let primaryButton: PrimaryButtonRule?
    
    init(
        destinationInput: DestinationInputRule? = nil,
        receiptEmailInput: ReceiptEmailInputRule? = nil,
        label: LabelRule? = nil,
        input: InputRule? = nil,
        tab: TabRule? = nil,
        primaryButton: PrimaryButtonRule? = nil
    ) {
        self.destinationInput = destinationInput
        self.receiptEmailInput = receiptEmailInput
        self.label = label
        self.input = input
        self.tab = tab
        self.primaryButton = primaryButton
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let destinationInput = destinationInput, !destinationInput.toDictionary().isEmpty {
            dict["DestinationInput"] = destinationInput.toDictionary()
        }
        if let receiptEmailInput = receiptEmailInput, !receiptEmailInput.toDictionary().isEmpty {
            dict["ReceiptEmailInput"] = receiptEmailInput.toDictionary()
        }
        if let label = label, !label.toDictionary().isEmpty {
            dict["Label"] = label.toDictionary()
        }
        if let input = input, !input.toDictionary().isEmpty {
            dict["Input"] = input.toDictionary()
        }
        if let tab = tab, !tab.toDictionary().isEmpty {
            dict["Tab"] = tab.toDictionary()
        }
        if let primaryButton = primaryButton, !primaryButton.toDictionary().isEmpty {
            dict["PrimaryButton"] = primaryButton.toDictionary()
        }
        return dict
    }
}

// MARK: - Appearance

struct Appearance {
    let rules: AppearanceRules?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let rules = rules, !rules.toDictionary().isEmpty {
            dict["rules"] = rules.toDictionary()
        }
        return dict
    }
}

