//
//  ProviderNavigationView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI
import MapKit

struct ProviderNavigationView: View {
    @ObservedObject var viewModel: ProviderMatchViewModel
    @ObservedObject var userViewModel: UserViewModel
    let riskLevel: AssessmentResult.RiskLevel
    
    @State private var showMapView = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Connect to Care")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("\(viewModel.filteredProviders.count) providers near you")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showMapView.toggle()
                    }) {
                        Image(systemName: showMapView ? "list.bullet" : "map.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            .frame(width: 44, height: 44)
                            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                            .cornerRadius(22)
                    }
                    .accessibilityLabel(showMapView ? "Show list view" : "Show map view")
                }
                .padding()
                
                // Emergency banner for high risk
                if riskLevel == .high {
                    EmergencyBanner()
                        .padding(.horizontal)
                }
            }
            .background(Color.white)
            
            Divider()
            
            // Content
            if showMapView {
                MapView(viewModel: viewModel)
            } else {
                ProviderListView(viewModel: viewModel)
            }
        }
        .navigationTitle("Find Care")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadProviders(for: userViewModel.user)
        }
    }
}

struct MapView: View {
    @ObservedObject var viewModel: ProviderMatchViewModel
    @State private var selectedProvider: ProviderModel?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $viewModel.mapPosition) {
                ForEach(viewModel.filteredProviders) { provider in
                    Annotation(provider.name, coordinate: provider.coordinates) {
                        Button(action: {
                            selectedProvider = provider
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color(red: 0.01, green: 0.49, blue: 0.94))
                                    .cornerRadius(20)
                                    .shadow(radius: 4)
                                
                                if selectedProvider?.id == provider.id {
                                    Text(provider.name)
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color.white)
                                        .cornerRadius(4)
                                        .shadow(radius: 2)
                                }
                            }
                        }
                        .accessibilityLabel("\(provider.name), \(String(format: "%.1f", provider.distance)) miles away")
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Selected Provider Card
            if let provider = selectedProvider {
                ProviderListItem(
                    provider: provider,
                    onCallTapped: {
                        viewModel.makePhoneCall(to: provider.phoneNumber)
                    },
                    onDirectionsTapped: {
                        viewModel.openMaps(for: provider)
                    },
                    onBookTapped: {
                        // Handle telemedicine booking
                    }
                )
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

struct ProviderListView: View {
    @ObservedObject var viewModel: ProviderMatchViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredProviders) { provider in
                    ProviderListItem(
                        provider: provider,
                        onCallTapped: {
                            viewModel.makePhoneCall(to: provider.phoneNumber)
                        },
                        onDirectionsTapped: {
                            viewModel.openMaps(for: provider)
                        },
                        onBookTapped: {
                            // Handle telemedicine booking
                        }
                    )
                }
                
                // Empty state
                if viewModel.filteredProviders.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "mappin.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No providers found")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("Try adjusting your location or insurance preferences")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                }
            }
            .padding()
        }
    }
}

struct EmergencyBanner: View {
    var body: some View {
        CardView(backgroundColor: Color.red.opacity(0.15)) {
            HStack(spacing: 12) {
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Emergency?")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                    
                    Text("Call 911 for immediate assistance")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button(action: {
                    if let url = URL(string: "tel://911"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Call")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .accessibilityLabel("Call 911")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProviderNavigationView(
            viewModel: ProviderMatchViewModel(),
            userViewModel: UserViewModel(),
            riskLevel: .moderate
        )
    }
}

