//
//  CustomButton.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void
    var isDisabled: Bool = false
    
    enum ButtonStyle {
        case primary
        case secondary
        case danger
        case outlined
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color(red: 0.01, green: 0.49, blue: 0.94) // #027ef1
            case .secondary:
                return Color(red: 0.22, green: 0.71, blue: 1.0) // #38b6ff
            case .danger:
                return Color.red
            case .outlined:
                return Color.clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .outlined:
                return Color(red: 0.01, green: 0.49, blue: 0.94)
            default:
                return .white
            }
        }
        
        var borderColor: Color {
            switch self {
            case .outlined:
                return Color(red: 0.01, green: 0.49, blue: 0.94)
            default:
                return .clear
            }
        }
    }
    
    init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isDisabled ? Color.gray.opacity(0.3) : style.backgroundColor
            )
            .foregroundColor(
                isDisabled ? Color.gray : style.foregroundColor
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style.borderColor, lineWidth: 2)
            )
        }
        .disabled(isDisabled)
        .accessibilityLabel(title)
        .accessibilityHint(isDisabled ? "Button is disabled" : "")
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton("Get Started", icon: "arrow.right", style: .primary) {}
        CustomButton("Continue", style: .secondary) {}
        CustomButton("Emergency Call", icon: "phone.fill", style: .danger) {}
        CustomButton("Learn More", style: .outlined) {}
        CustomButton("Disabled", style: .primary, isDisabled: true) {}
    }
    .padding()
}

