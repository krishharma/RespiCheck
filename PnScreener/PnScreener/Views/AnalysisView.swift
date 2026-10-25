//
//  AnalysisView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct AnalysisView: View {
    @ObservedObject var viewModel: AudioAnalyzerViewModel
    @Binding var showNextScreen: Bool
    
    @State private var animationPhase = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Animated Analysis Indicator
                ZStack {
                    // Outer pulse rings
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(
                                Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.3 - Double(index) * 0.1),
                                lineWidth: 2
                            )
                            .frame(width: 200 + CGFloat(index) * 40, height: 200 + CGFloat(index) * 40)
                            .scaleEffect(pulseScale)
                            .opacity(2.0 - pulseScale)
                            .animation(
                                Animation.easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                value: pulseScale
                            )
                    }
                    
                    // Center circle with waveform
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.01, green: 0.49, blue: 0.94),
                                        Color(red: 0.22, green: 0.71, blue: 1.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 180, height: 180)
                            .shadow(color: Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.4), radius: 20)
                        
                        WaveformView(isAnimating: true, color: .white)
                            .frame(width: 100, height: 60)
                    }
                }
                .frame(height: 280)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Analyzing your breathing")
                
                // Status Text
                VStack(spacing: 16) {
                    Text(statusMessage)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Text(statusSubtitle)
                        .font(.system(size: 17, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Info Card
                CardView {
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.22, green: 0.71, blue: 1.0))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("What's happening?")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                            
                            Text("Our AI is carefully analyzing your breathing patterns and symptom data to provide a personalized assessment.")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            pulseScale = 1.2
        }
        .onChange(of: viewModel.showAnalysisScreen) { oldValue, newValue in
            if newValue {
                // Small delay before transitioning
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showNextScreen = true
                }
            }
        }
    }
    
    private var statusMessage: String {
        switch viewModel.audioModel.uploadStatus {
        case .uploading:
            return "Uploading..."
        case .analyzing:
            return "Analyzing Your Breathing"
        case .completed:
            return "Analysis Complete"
        default:
            return "Processing..."
        }
    }
    
    private var statusSubtitle: String {
        switch viewModel.audioModel.uploadStatus {
        case .uploading:
            return "Securely uploading your recording"
        case .analyzing:
            return "This may take a moment"
        case .completed:
            return "Preparing your results"
        default:
            return "Please wait"
        }
    }
}

#Preview {
    NavigationStack {
        AnalysisView(
            viewModel: AudioAnalyzerViewModel(),
            showNextScreen: .constant(false)
        )
    }
}

