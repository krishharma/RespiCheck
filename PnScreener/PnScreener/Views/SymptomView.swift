//
//  SymptomView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct SymptomView: View {
    @ObservedObject var viewModel: SurveyViewModel
    @Binding var showNextScreen: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Step \(viewModel.survey.currentQuestionIndex + 1) of \(SurveyModel.SurveyQuestion.allCases.count)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ProgressIndicator(progress: viewModel.progress)
                    .frame(height: 6)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
            
            if let currentQuestion = viewModel.survey.currentQuestion {
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Question Icon
                    Image(systemName: currentQuestion.iconName)
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                        .accessibilityHidden(true)
                        .transition(.scale.combined(with: .opacity))
                    
                    // Question Text
                    Text(currentQuestion.questionText)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity)
                    
                    Spacer()
                    
                    // Answer Buttons
                    VStack(spacing: 16) {
                        AnswerButton(text: "Yes", icon: "checkmark.circle.fill", color: Color(red: 0.22, green: 0.83, blue: 0.62)) {
                            withAnimation {
                                viewModel.answerQuestion(.boolean(true))
                            }
                        }
                        
                        AnswerButton(text: "No", icon: "xmark.circle.fill", color: Color.gray) {
                            withAnimation {
                                viewModel.answerQuestion(.boolean(false))
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
                .id(currentQuestion) // Force view refresh for transitions
            } else {
                // Completed state
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                    
                    Text("Survey Complete!")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    
                    Text("Next, we'll record your cough for analysis")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    CustomButton("Continue", icon: "arrow.right", style: .primary) {
                        viewModel.saveSurvey()
                        showNextScreen = true
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("Symptom Checker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                }
                .accessibilityLabel("Help")
            }
        }
        .onChange(of: viewModel.showNextScreen) { newValue in
            if newValue {
                showNextScreen = true
            }
        }
    }
}

struct AnswerButton: View {
    let text: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                
                Text(text)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(color.opacity(isPressed ? 0.3 : 0.15))
            .foregroundColor(color)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color, lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: isPressed)
        }
        .accessibilityLabel("\(text) button")
        .accessibilityHint("Double tap to answer \(text)")
    }
}

#Preview {
    NavigationStack {
        SymptomView(
            viewModel: SurveyViewModel(),
            showNextScreen: .constant(false)
        )
    }
}

