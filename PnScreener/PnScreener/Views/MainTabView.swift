//
//  MainTabView.swift
//  PnScreener
//
//  Clean tab-based navigation
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var selectedTab = 0
    
    init() {
        // Customize tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        // Remove top border
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(userViewModel: userViewModel)
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            SymptomCheckerView()
                .tabItem {
                    Label("Symptoms", systemImage: selectedTab == 1 ? "list.clipboard.fill" : "list.clipboard")
                }
                .tag(1)
            
            VoiceAnalyzerView()
                .tabItem {
                    Label("Analyze", systemImage: selectedTab == 2 ? "waveform" : "waveform")
                }
                .tag(2)
            
            ResourcesView()
                .tabItem {
                    Label("Resources", systemImage: selectedTab == 3 ? "book.fill" : "book")
                }
                .tag(3)
            
            ProfileView(viewModel: userViewModel)
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 4 ? "person.fill" : "person")
                }
                .tag(4)
        }
        .accentColor(Color(red: 0.01, green: 0.49, blue: 0.94))
        .onAppear {
            // Add subtle shadow to tab bar
            UITabBar.appearance().layer.shadowColor = UIColor.black.cgColor
            UITabBar.appearance().layer.shadowOpacity = 0.1
            UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: -2)
            UITabBar.appearance().layer.shadowRadius = 8
        }
    }
}

#Preview {
    MainTabView()
}

