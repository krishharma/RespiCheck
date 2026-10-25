//
//  ProviderListItem.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct ProviderListItem: View {
    let provider: ProviderModel
    let onCallTapped: () -> Void
    let onDirectionsTapped: () -> Void
    let onBookTapped: () -> Void
    
    var body: some View {
        CardView(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(provider.name)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            Text("\(String(format: "%.1f", provider.distance)) mi")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    if provider.hasTelemedicine {
                        Image(systemName: "video.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                            .accessibilityLabel("Telemedicine available")
                    }
                }
                
                Divider()
                
                // Details
                VStack(alignment: .leading, spacing: 8) {
                    DetailRow(icon: "mappin.circle.fill", text: provider.address)
                    DetailRow(icon: "clock.fill", text: provider.hours)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                        
                        Text(insuranceText)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "globe")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                        
                        Text(languageText)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    ActionButton(icon: "phone.fill", label: "Call", action: onCallTapped)
                    ActionButton(icon: "location.fill", label: "Directions", action: onDirectionsTapped)
                    if provider.hasTelemedicine {
                        ActionButton(icon: "video.fill", label: "Book", action: onBookTapped)
                    }
                }
                .padding(.top, 4)
            }
        }
        .accessibilityElement(children: .contain)
    }
    
    private var insuranceText: String {
        let types = provider.acceptsInsurance.map { $0.rawValue }
        return types.joined(separator: ", ")
    }
    
    private var languageText: String {
        let languages = provider.languagesSupported.map { $0.rawValue }
        return languages.joined(separator: ", ")
    }
}

struct DetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                .frame(width: 16)
            
            Text(text)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(label)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color(red: 0.01, green: 0.49, blue: 0.94))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .accessibilityLabel("\(label) \(label == "Call" ? "provider" : "")")
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(ProviderModel.mockProviders.prefix(2)) { provider in
                ProviderListItem(
                    provider: provider,
                    onCallTapped: {},
                    onDirectionsTapped: {},
                    onBookTapped: {}
                )
            }
        }
        .padding()
    }
}

