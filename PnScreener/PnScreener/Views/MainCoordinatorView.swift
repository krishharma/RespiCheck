//
//  MainCoordinatorView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

enum AppScreen {
    case splash
    case userInfo
    case symptomSurvey
    case audioCapture
    case analysis
    case results
    case providerNavigation
    case resources
    case settings
}

struct MainCoordinatorView: View {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var surveyViewModel = SurveyViewModel()
    @StateObject private var audioViewModel = AudioAnalyzerViewModel()
    @StateObject private var providerViewModel = ProviderMatchViewModel()
    
    @State private var hasCompletedSplash = false
    @State private var selectedLanguage: UserModel.AppLanguage = .english
    @State private var navigationPath = NavigationPath()
    @State private var currentScreen: AppScreen = .splash
    
    var body: some View {
        Group {
            if !hasCompletedSplash {
                SplashView(
                    selectedLanguage: $selectedLanguage,
                    hasCompletedSplash: $hasCompletedSplash
                )
            } else {
                NavigationStack(path: $navigationPath) {
                    UserInfoView(
                        viewModel: userViewModel,
                        showNextScreen: .constant(false)
                    )
                    .navigationDestination(for: AppScreen.self) { screen in
                        destinationView(for: screen)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(value: AppScreen.settings) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            }
                            .accessibilityLabel("Settings")
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink(value: AppScreen.resources) {
                                Image(systemName: "book.fill")
                                    .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            }
                            .accessibilityLabel("Resources")
                        }
                    }
                }
                .onAppear {
                    userViewModel.user.language = selectedLanguage
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for screen: AppScreen) -> some View {
        switch screen {
        case .splash:
            SplashView(
                selectedLanguage: $selectedLanguage,
                hasCompletedSplash: $hasCompletedSplash
            )
            
        case .userInfo:
            UserInfoView(
                viewModel: userViewModel,
                showNextScreen: binding(for: .symptomSurvey)
            )
            
        case .symptomSurvey:
            SymptomView(
                viewModel: surveyViewModel,
                showNextScreen: binding(for: .audioCapture)
            )
            
        case .audioCapture:
            AudioCaptureView(
                viewModel: audioViewModel,
                showNextScreen: binding(for: .analysis)
            )
            
        case .analysis:
            AnalysisView(
                viewModel: audioViewModel,
                showNextScreen: binding(for: .results)
            )
            
        case .results:
            if let result = audioViewModel.assessmentResult {
                ResultsView(
                    result: result,
                    showNextScreen: binding(for: .providerNavigation)
                )
            }
            
        case .providerNavigation:
            ProviderNavigationView(
                viewModel: providerViewModel,
                userViewModel: userViewModel,
                riskLevel: audioViewModel.assessmentResult?.riskLevel ?? .moderate
            )
            
        case .resources:
            ResourcesView()
            
        case .settings:
            SettingsView(userViewModel: userViewModel)
        }
    }
    
    private func binding(for nextScreen: AppScreen) -> Binding<Bool> {
        Binding(
            get: { false },
            set: { newValue in
                if newValue {
                    navigationPath.append(nextScreen)
                }
            }
        )
    }
}

// Alternative simpler navigation approach
struct SimpleNavigationView: View {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var surveyViewModel = SurveyViewModel()
    @StateObject private var audioViewModel = AudioAnalyzerViewModel()
    @StateObject private var providerViewModel = ProviderMatchViewModel()
    
    @State private var hasCompletedSplash = false
    @State private var selectedLanguage: UserModel.AppLanguage = .english
    @State private var showUserInfo = false
    @State private var showSymptoms = false
    @State private var showAudio = false
    @State private var showAnalysis = false
    @State private var showResults = false
    @State private var showProviders = false
    
    var body: some View {
        Group {
            if !hasCompletedSplash {
                SplashView(
                    selectedLanguage: $selectedLanguage,
                    hasCompletedSplash: $hasCompletedSplash
                )
            } else {
                NavigationStack {
                    UserInfoView(
                        viewModel: userViewModel,
                        showNextScreen: $showSymptoms
                    )
                    .navigationDestination(isPresented: $showSymptoms) {
                        SymptomView(
                            viewModel: surveyViewModel,
                            showNextScreen: $showAudio
                        )
                    }
                    .navigationDestination(isPresented: $showAudio) {
                        AudioCaptureView(
                            viewModel: audioViewModel,
                            showNextScreen: $showAnalysis
                        )
                    }
                    .navigationDestination(isPresented: $showAnalysis) {
                        AnalysisView(
                            viewModel: audioViewModel,
                            showNextScreen: $showResults
                        )
                    }
                    .navigationDestination(isPresented: $showResults) {
                        if let result = audioViewModel.assessmentResult {
                            ResultsView(
                                result: result,
                                showNextScreen: $showProviders
                            )
                        }
                    }
                    .navigationDestination(isPresented: $showProviders) {
                        ProviderNavigationView(
                            viewModel: providerViewModel,
                            userViewModel: userViewModel,
                            riskLevel: audioViewModel.assessmentResult?.riskLevel ?? .moderate
                        )
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: SettingsView(userViewModel: userViewModel)) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            }
                            .accessibilityLabel("Settings")
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink(destination: ResourcesView()) {
                                Image(systemName: "book.fill")
                                    .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            }
                            .accessibilityLabel("Resources")
                        }
                    }
                }
                .onAppear {
                    userViewModel.user.language = selectedLanguage
                }
            }
        }
    }
}

#Preview {
    SimpleNavigationView()
}

