//
//  ResultsView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct ResultsView: View {
    let result: AssessmentResult
    @Binding var showNextScreen: Bool
    
    @State private var showExplanation = false
    @State private var scaleEffect = 0.8
    @State private var opacity = 0.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Risk Level Card
                CardView(backgroundColor: riskBackgroundColor) {
                    VStack(spacing: 20) {
                        // Warning Icon for High Risk
                        if result.riskLevel == .high {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                                .accessibilityLabel("Warning")
                        }
                        
                        Text("Assessment Result")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        // Risk Level
                        HStack(spacing: 12) {
                            Circle()
                                .fill(riskColor)
                                .frame(width: 16, height: 16)
                            
                            Text("\(result.riskLevel.rawValue) Risk")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        .scaleEffect(scaleEffect)
                        .opacity(opacity)
                        
                        // Description
                        Text(result.riskLevel.description)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
                
                // Confidence
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            
                            Text("Assessment Confidence")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                        
                        HStack {
                            ProgressIndicator(
                                progress: result.confidence,
                                height: 12,
                                accentColor: Color(red: 0.22, green: 0.83, blue: 0.62)
                            )
                            
                            Text("\(Int(result.confidence * 100))%")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                                .frame(width: 50, alignment: .trailing)
                        }
                        .frame(height: 12)
                    }
                }
                
                // Risk Factors
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Summary of Your Results")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Spacer()
                        }
                        
                        ForEach(result.factors) { factor in
                            RiskFactorRow(factor: factor)
                        }
                    }
                }
                
                // How was this calculated
                ExpandableCard(
                    title: "How is this score calculated?",
                    icon: "questionmark.circle.fill",
                    content: "Your risk assessment is based on multiple factors including your reported symptoms, cough audio analysis using AI pattern recognition, and demographic information. Our algorithm compares your data against validated clinical criteria for respiratory conditions."
                )
                
                // Next Steps
                if result.riskLevel == .high {
                    CardView(backgroundColor: Color.red.opacity(0.1)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 24))
                                
                                Text("Urgent Action Needed")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.red)
                            }
                            
                            Text("Based on your assessment, we strongly recommend seeking medical attention as soon as possible.")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            CustomButton(
                                "Find Care Now",
                                icon: "cross.case.fill",
                                style: .danger
                            ) {
                                showNextScreen = true
                            }
                        }
                    }
                } else {
                    CustomButton(
                        "See Recommended Next Steps",
                        icon: "arrow.right",
                        style: .primary
                    ) {
                        showNextScreen = true
                    }
                    .padding(.horizontal)
                }
                
                // Disclaimer
                Text("This is not a medical diagnosis. Please consult a healthcare professional for medical advice.")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
            }
            .padding()
        }
        .navigationTitle("Your Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6)) {
                scaleEffect = 1.0
                opacity = 1.0
            }
        }
    }
    
    private var riskColor: Color {
        switch result.riskLevel {
        case .low:
            return Color(red: 0.22, green: 0.83, blue: 0.62)
        case .moderate:
            return Color.orange
        case .high:
            return Color.red
        }
    }
    
    private var riskBackgroundColor: Color {
        switch result.riskLevel {
        case .low:
            return Color(red: 0.22, green: 0.83, blue: 0.62).opacity(0.1)
        case .moderate:
            return Color.orange.opacity(0.1)
        case .high:
            return Color.red.opacity(0.1)
        }
    }
}

struct RiskFactorRow: View {
    let factor: AssessmentResult.RiskFactor
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: factor.isPresent ? "checkmark.circle.fill" : "circle")
                .foregroundColor(
                    factor.isPresent ? 
                    severityColor : 
                    Color.gray.opacity(0.3)
                )
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(factor.name)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(factor.severity)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private var severityColor: Color {
        switch factor.severity.lowercased() {
        case "low":
            return Color(red: 0.22, green: 0.83, blue: 0.62)
        case "moderate":
            return Color.orange
        case "high":
            return Color.red
        default:
            return Color.gray
        }
    }
}

#Preview {
    NavigationStack {
        ResultsView(
            result: AssessmentResult.mock(riskLevel: .moderate),
            showNextScreen: .constant(false)
        )
    }
}

