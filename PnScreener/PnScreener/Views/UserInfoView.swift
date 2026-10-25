//
//  UserInfoView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: UserViewModel
    @Binding var showNextScreen: Bool
    @State private var showLocationSheet = false
    @State private var showHelp = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.text.rectangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                        .accessibilityHidden(true)
                    
                    Text("Let's Get Your Profile Set Up")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us personalize your experience")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Location Section
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Enable Location Services", systemImage: "location.fill")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        
                        Text("Location is used to find nearby clinics and provide localized health information.")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        CustomButton(
                            viewModel.locationPermissionGranted ? "Location Enabled" : "Allow Location Access",
                            icon: "location.circle.fill",
                            style: viewModel.locationPermissionGranted ? .secondary : .primary
                        ) {
                            if !viewModel.locationPermissionGranted {
                                viewModel.requestLocationPermission()
                            }
                            viewModel.getCurrentLocation()
                        }
                        
                        if viewModel.user.location != nil {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                                Text(viewModel.user.location ?? "")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            TextField("Or enter ZIP code manually", text: $viewModel.manualLocation)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .accessibilityLabel("ZIP code")
                        }
                    }
                }
                
                // Insurance & Language
                CardView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Insurance & Language")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Do you have health insurance?")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(UserModel.InsuranceType.allCases, id: \.self) { type in
                                    InsuranceButton(
                                        type: type,
                                        isSelected: viewModel.user.insuranceType == type
                                    ) {
                                        viewModel.user.insuranceType = type
                                    }
                                }
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What is your preferred language?")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            
                            Picker("Language", selection: $viewModel.user.language) {
                                ForEach(UserModel.AppLanguage.allCases, id: \.self) { language in
                                    Text(language.rawValue).tag(language)
                                }
                            }
                            .pickerStyle(.segmented)
                            .accessibilityLabel("Preferred language")
                        }
                    }
                }
                
                // Demographics (Optional)
                CardView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Help Us Personalize Your Experience")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Spacer()
                            
                            Button(action: { showHelp = true }) {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            }
                            .accessibilityLabel("Help information")
                        }
                        
                        Text("(Optional)")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        Text("This data improves assessment accuracy.")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.secondary)
                            .italic()
                        
                        // Age
                        HStack {
                            Text("Age:")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .frame(width: 80, alignment: .leading)
                            
                            TextField("Enter age", value: $viewModel.user.age, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .accessibilityLabel("Age")
                        }
                        
                        // Gender
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gender:")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            
                            Picker("Gender", selection: $viewModel.user.gender) {
                                Text("Select").tag(nil as UserModel.Gender?)
                                ForEach(UserModel.Gender.allCases, id: \.self) { gender in
                                    Text(gender.rawValue).tag(gender as UserModel.Gender?)
                                }
                            }
                            .pickerStyle(.menu)
                            .accessibilityLabel("Gender")
                        }
                    }
                }
                
                // Continue Button
                CustomButton(
                    "Continue",
                    icon: "arrow.right",
                    style: .primary,
                    isDisabled: !isFormValid
                ) {
                    viewModel.saveUserData()
                    showNextScreen = true
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // Privacy footer
                Text("Your data is secure. Read our Privacy Policy")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("Profile Setup")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Why We Ask", isPresented: $showHelp) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Optional demographic information helps improve the accuracy of our assessment. Your data is never shared without your consent.")
        }
    }
    
    private var isFormValid: Bool {
        (viewModel.user.location != nil || !viewModel.manualLocation.isEmpty)
    }
}

struct InsuranceButton: View {
    let type: UserModel.InsuranceType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(
                        isSelected ? 
                        Color(red: 0.01, green: 0.49, blue: 0.94) : 
                        Color.gray
                    )
                
                Text(shortLabel)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular, design: .rounded))
                    .foregroundColor(isSelected ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? 
                Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.1) : 
                Color.gray.opacity(0.05)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? 
                        Color(red: 0.01, green: 0.49, blue: 0.94) : 
                        Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .accessibilityLabel(type.rawValue)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
    
    private var shortLabel: String {
        switch type {
        case .privateInsurance:
            return "Private"
        case .medicaid:
            return "Medicaid"
        case .uninsured:
            return "Uninsured"
        case .unknown:
            return "I prefer not to say"
        }
    }
}

#Preview {
    NavigationStack {
        UserInfoView(
            viewModel: UserViewModel(),
            showNextScreen: .constant(false)
        )
    }
}

