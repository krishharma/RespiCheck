//
//  SymptomCheckerView.swift
//  PnScreener
//
//  Research-validated symptom assessment (CDC, WHO, ATS, IDSA)
//

import SwiftUI

struct SymptomCheckerView: View {
    @StateObject private var viewModel = SurveyViewModel()
    @State private var showResults = false
    @State private var hasStarted = false
    @State private var showEmergencyAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 0.98)
                    .ignoresSafeArea()
                
                if !hasStarted {
                    StartScreen(hasStarted: $hasStarted)
                        .transition(.opacity.combined(with: .scale))
                } else if !viewModel.survey.isComplete {
                    QuestionScreenNew(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                } else {
                    CompletionScreen(
                        onContinue: { showResults = true },
                        onRestart: { 
                            viewModel.clearSurvey()
                            hasStarted = false
                        },
                        hasEmergencySymptoms: viewModel.survey.hasEmergencySymptoms
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationTitle("Symptom Checker")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: hasStarted)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.survey.isComplete)
            .alert("⚠️ Seek Immediate Care", isPresented: $showEmergencyAlert) {
                Button("Call 911", role: .destructive) {
                    if let url = URL(string: "tel://911") {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Continue Assessment", role: .cancel) {}
            } message: {
                Text("You've indicated emergency symptoms. Please seek immediate medical attention or call 911 if this is a medical emergency.")
            }
        }
    }
}

struct StartScreen: View {
    @Binding var hasStarted: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "list.clipboard.fill")
                .font(.system(size: 80))
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
            
            VStack(spacing: 12) {
                Text("Symptom Assessment")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text("Answer research-validated questions about your symptoms for a personalized health assessment")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(icon: "clock.fill", text: "Takes 3-5 minutes")
                InfoRow(icon: "lock.shield.fill", text: "Your data stays private")
                InfoRow(icon: "checkmark.seal.fill", text: "Based on CDC & WHO guidelines")
                InfoRow(icon: "stethoscope", text: "21 evidence-based questions")
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    hasStarted = true
                }
            }) {
                HStack(spacing: 12) {
                    Text("Start Assessment")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.01, green: 0.49, blue: 0.94),
                            Color(red: 0.22, green: 0.71, blue: 1.0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

struct QuestionScreenNew: View {
    @ObservedObject var viewModel: SurveyViewModel
    @State private var selectedOptions: Set<String> = []
    @State private var selectedOption: String?
    @State private var showEmergencyWarning = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            VStack(spacing: 16) {
                HStack {
                    Text("Question \(viewModel.survey.currentQuestionIndex + 1) of \(SurveyModel.SurveyQuestion.allCases.count)")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let question = viewModel.survey.currentQuestion, question.isOptional {
                        Text("Optional")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 24)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.01, green: 0.49, blue: 0.94),
                                        Color(red: 0.22, green: 0.71, blue: 1.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(viewModel.progress), height: 8)
                            .animation(.spring(response: 0.5), value: viewModel.progress)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, 24)
            }
            .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 40) {
                    if let question = viewModel.survey.currentQuestion {
                        // Icon and Question
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(iconColor(for: question).opacity(0.1))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: question.iconName)
                                    .font(.system(size: 42, weight: .medium))
                                    .foregroundColor(iconColor(for: question))
                            }
                            .padding(.top, 20)
                            
                            Text(question.questionText)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .id(question)
                        
                        // Answer Options
                        answerView(for: question)
                            .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .alert("⚠️ Emergency Symptoms Detected", isPresented: $showEmergencyWarning) {
            Button("Call 911 Now", role: .destructive) {
                if let url = URL(string: "tel://911") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Continue", role: .cancel) {
                advanceToNext()
            }
        } message: {
            Text("You've indicated serious symptoms that may require immediate medical attention. Please call 911 or go to the nearest emergency room if this is a medical emergency.")
        }
    }
    
    @ViewBuilder
    private func answerView(for question: SurveyModel.SurveyQuestion) -> some View {
        switch question.questionType {
        case .yesNo:
            VStack(spacing: 16) {
                YesNoButton(text: "Yes", isYes: true) {
                    viewModel.answerQuestion(.boolean(true))
                }
                YesNoButton(text: "No", isYes: false) {
                    viewModel.answerQuestion(.boolean(false))
                }
            }
            
        case .yesNoNotSure:
            VStack(spacing: 16) {
                YesNoButton(text: "Yes", isYes: true) {
                    viewModel.answerQuestion(.boolean(true))
                }
                YesNoButton(text: "No", isYes: false) {
                    viewModel.answerQuestion(.boolean(false))
                }
                NotSureButton {
                    viewModel.answerQuestion(.option("Not sure"))
                }
            }
            
        case .singleChoice(let options):
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    OptionButton(
                        text: option,
                        isSelected: selectedOption == option
                    ) {
                        selectedOption = option
                        viewModel.answerQuestion(.option(option))
                    }
                }
            }
            
        case .multipleSelect(let options):
            VStack(spacing: 16) {
                if question == .emergencySymptoms {
                    Text("Select all that apply")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        MultiSelectButton(
                            text: option,
                            isSelected: selectedOptions.contains(option),
                            isEmergency: question == .emergencySymptoms && option != "None of the above"
                        ) {
                            toggleSelection(option, isNoneOption: option == "None of the above")
                        }
                    }
                }
                
                Button(action: {
                    if question == .emergencySymptoms && hasEmergencySelected() {
                        showEmergencyWarning = true
                    } else {
                        advanceToNext()
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.01, green: 0.49, blue: 0.94))
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
        }
    }
    
    private func toggleSelection(_ option: String, isNoneOption: Bool) {
        if isNoneOption {
            // If "None" is selected, clear all others
            selectedOptions.removeAll()
            selectedOptions.insert(option)
        } else {
            // If anything else is selected, remove "None"
            selectedOptions.remove("None of the above")
            
            if selectedOptions.contains(option) {
                selectedOptions.remove(option)
            } else {
                selectedOptions.insert(option)
            }
        }
    }
    
    private func hasEmergencySelected() -> Bool {
        return !selectedOptions.isEmpty && !selectedOptions.contains("None of the above")
    }
    
    private func advanceToNext() {
        viewModel.answerQuestion(.multipleOptions(selectedOptions))
        selectedOptions.removeAll()
        selectedOption = nil
    }
    
    private func iconColor(for question: SurveyModel.SurveyQuestion) -> Color {
        if question == .emergencySymptoms {
            return .red
        } else if question == .confusion {
            return .orange
        } else {
            return Color(red: 0.01, green: 0.49, blue: 0.94)
        }
    }
}

struct YesNoButton: View {
    let text: String
    let isYes: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var color: Color {
        isYes ? Color(red: 0.22, green: 0.83, blue: 0.62) : Color.gray
    }
    
    var body: some View {
        Button(action: {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: isYes ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                Text(text)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color, lineWidth: 2)
            )
            .shadow(color: color.opacity(isPressed ? 0.3 : 0.15), radius: isPressed ? 5 : 10, x: 0, y: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NotSureButton: View {
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
            HStack(spacing: 12) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 20))
                Text("Not Sure")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(16)
            .background(isSelected ? Color(red: 0.01, green: 0.49, blue: 0.94) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(red: 0.01, green: 0.49, blue: 0.94) : Color.gray.opacity(0.2), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MultiSelectButton: View {
    let text: String
    let isSelected: Bool
    let isEmergency: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundColor(isEmergency && isSelected ? .red : (isSelected ? Color(red: 0.01, green: 0.49, blue: 0.94) : Color.gray.opacity(0.4)))
                
                Text(text)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(isEmergency ? .red : .primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .background(isEmergency && isSelected ? Color.red.opacity(0.1) : (isSelected ? Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.1) : Color.white))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isEmergency && isSelected ? Color.red : 
                        (isSelected ? Color(red: 0.01, green: 0.49, blue: 0.94) : Color.gray.opacity(0.2)),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.primary)
        }
    }
}

struct CompletionScreen: View {
    let onContinue: () -> Void
    let onRestart: () -> Void
    let hasEmergencySymptoms: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if hasEmergencySymptoms {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    
                    VStack(spacing: 12) {
                        Text("Emergency Symptoms Detected")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                        
                        Text("Based on your responses, you should seek immediate medical attention.")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                
                VStack(spacing: 12) {
                    Text("Assessment Complete!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Text("Your responses have been recorded. Continue to voice analysis for a complete evaluation.")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                if hasEmergencySymptoms {
                    Button(action: {
                        if let url = URL(string: "tel://911") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call 911")
                        }
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.red)
                        .cornerRadius(16)
                    }
                }
                
                Button(action: onContinue) {
                    Text(hasEmergencySymptoms ? "Find Nearest Emergency Room" : "Continue to Voice Analysis")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(red: 0.01, green: 0.49, blue: 0.94))
                        .cornerRadius(16)
                }
                
                Button(action: onRestart) {
                    Text("Start Over")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    SymptomCheckerView()
}
