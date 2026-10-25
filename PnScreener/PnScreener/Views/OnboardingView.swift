//
//  OnboardingView.swift
//  PnScreener
//
//  Beautiful onboarding experience
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var selectedLanguage: UserModel.AppLanguage = .english
    
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
            
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                    
                    OnboardingPage2()
                        .tag(1)
                    
                    OnboardingPage3()
                        .tag(2)
                    
                    OnboardingPage4(
                        selectedLanguage: $selectedLanguage,
                        onGetStarted: {
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                hasCompletedOnboarding = true
                            }
                        }
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 100))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                Text("Welcome to RespiCheck")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Your personal respiratory health companion")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            Text("Swipe to continue →")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom, 20)
        }
        .padding()
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 200, height: 200)
                
                Image(systemName: "list.clipboard.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 16) {
                Text("Symptom Checker")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Answer simple questions about your symptoms to get a personalized health assessment")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage3: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 200, height: 200)
                
                Image(systemName: "waveform")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 16) {
                Text("AI Voice Analysis")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Record your cough and let our AI analyze patterns to assess respiratory health")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage4: View {
    @Binding var selectedLanguage: UserModel.AppLanguage
    let onGetStarted: () -> Void
    @State private var showLanguageSheet = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    Text("Your Privacy Matters")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your health data stays on your device. We never share your information without permission.")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            // Language Selector
            Button(action: {
                showLanguageSheet = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "globe")
                        .font(.system(size: 18))
                    Text(selectedLanguage.rawValue)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.2))
                .cornerRadius(25)
            }
            
            Spacer()
            
            Button(action: onGetStarted) {
                HStack(spacing: 12) {
                    Text("Get Started")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .padding()
        .confirmationDialog("Select Language", isPresented: $showLanguageSheet, titleVisibility: .visible) {
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
    OnboardingView(hasCompletedOnboarding: .constant(false))
}

