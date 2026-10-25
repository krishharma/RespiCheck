//
//  CardView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var backgroundColor: Color = Color(red: 0.98, green: 0.98, blue: 0.98)
    var padding: CGFloat = 16
    
    init(
        backgroundColor: Color = Color(red: 0.98, green: 0.98, blue: 0.98),
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ExpandableCard: View {
    let title: String
    let icon: String
    let content: String
    @State private var isExpanded = false
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            .frame(width: 40, height: 40)
                        
                        Text(title)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.secondary)
                    }
                }
                .accessibilityLabel("\(title). \(isExpanded ? "Expanded" : "Collapsed")")
                .accessibilityHint("Double tap to \(isExpanded ? "collapse" : "expand")")
                
                if isExpanded {
                    Text(content)
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView {
            VStack(alignment: .leading) {
                Text("Card Title")
                    .font(.headline)
                Text("This is a card with custom content")
                    .font(.subheadline)
            }
        }
        
        ExpandableCard(
            title: "What is pneumonia?",
            icon: "info.circle.fill",
            content: "Pneumonia is an infection that inflames air sacs in one or both lungs, which may fill with fluid."
        )
    }
    .padding()
}

