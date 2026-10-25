//
//  SplashView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var showLanguageSheet = false
    @Binding var selectedLanguage: UserModel.AppLanguage
    @Binding var hasCompletedSplash: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.01, green: 0.49, blue: 0.94),
                    Color(red: 0.22, green: 0.71, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo
                VStack(spacing: 20) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.white)
                        .accessibilityHidden(true)
                    
                    Text("RespiCheck")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("RespiCheck")
                
                // Tagline
                Text("Screen for pneumonia risk and connect to care")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                // Language Selector
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "globe")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showLanguageSheet = true
                        }) {
                            HStack {
                                Text(selectedLanguage.rawValue)
                                    .font(.system(size: 17, design: .rounded))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(.white)
                        }
                        .accessibilityLabel("Select language. Currently \(selectedLanguage.rawValue)")
                        .accessibilityHint("Double tap to change language")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(25)
                    
                    // Get Started Button
                    CustomButton(
                        "Get Started",
                        icon: "arrow.right",
                        style: .outlined
                    ) {
                        hasCompletedSplash = true
                    }
                    .padding(.horizontal, 32)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                            .padding(.horizontal, 32)
                    )
                    .foregroundColor(.white)
                    
                    // Privacy notice
                    HStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 16))
                        Text("Your privacy is important!")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Your privacy is important")
                }
                .padding(.bottom, 40)
            }
        }
        .confirmationDialog("Select Your Language", isPresented: $showLanguageSheet, titleVisibility: .visible) {
            ForEach(UserModel.AppLanguage.allCases, id: \.self) { language in
                Button(language.rawValue) {
                    selectedLanguage = language
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    SplashView(
        selectedLanguage: .constant(.english),
        hasCompletedSplash: .constant(false)
    )
}

