//
//  HomeView.swift
//  PnScreener
//
//  Clean home screen with feature cards
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var showingWelcome = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section
                    VStack(spacing: 16) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.01, green: 0.49, blue: 0.94),
                                        Color(red: 0.22, green: 0.71, blue: 1.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(.top, 40)
                        
                        VStack(spacing: 8) {
                            Text("Welcome to RespiCheck")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                            
                            Text("Your respiratory health companion")
                                .font(.system(size: 17, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                    
                    // Feature Cards
                    VStack(spacing: 20) {
                        FeatureCard(
                            icon: "list.clipboard.fill",
                            title: "Symptom Checker",
                            description: "Answer questions about your symptoms",
                            color: Color(red: 0.01, green: 0.49, blue: 0.94),
                            action: {}
                        )
                        
                        FeatureCard(
                            icon: "waveform",
                            title: "Voice Analyzer",
                            description: "Record your cough for AI analysis",
                            color: Color(red: 0.22, green: 0.83, blue: 0.62),
                            action: {}
                        )
                        
                        FeatureCard(
                            icon: "map.fill",
                            title: "Find Care",
                            description: "Locate nearby healthcare providers",
                            color: Color.orange,
                            action: {}
                        )
                        
                        FeatureCard(
                            icon: "book.fill",
                            title: "Learn More",
                            description: "Educational resources about respiratory health",
                            color: Color.purple,
                            action: {}
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                    // Quick Stats (if user has data)
                    if userViewModel.user.age != nil {
                        QuickStatsCard()
                            .padding(.horizontal, 24)
                            .padding(.bottom, 40)
                    }
                }
            }
            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 20) {
                // Icon Circle
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: icon)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(color)
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(isPressed ? 0.1 : 0.05), radius: isPressed ? 5 : 10, x: 0, y: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint(description)
    }
}

struct QuickStatsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Activity")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                StatItem(icon: "checkmark.circle.fill", value: "0", label: "Screenings", color: Color(red: 0.22, green: 0.83, blue: 0.62))
                StatItem(icon: "waveform.path", value: "0", label: "Recordings", color: Color(red: 0.01, green: 0.49, blue: 0.94))
                StatItem(icon: "heart.fill", value: "—", label: "Status", color: Color.orange)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView(userViewModel: UserViewModel())
}

