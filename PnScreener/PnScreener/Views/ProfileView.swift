//
//  ProfileView.swift
//  PnScreener
//
//  Clean profile management screen
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: UserViewModel
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 0.98)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
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
                                    .frame(width: 100, height: 100)
                                
                                Text(viewModel.user.age != nil ? "\(viewModel.user.age!)" : "")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                if viewModel.user.age == nil {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 30)
                            
                            VStack(spacing: 4) {
                                Text("Your Profile")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                
                                if let location = viewModel.user.location {
                                    Text(location)
                                        .font(.system(size: 14, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        
                        // Profile Info Cards
                        VStack(spacing: 16) {
                            ProfileInfoCard(
                                icon: "location.fill",
                                title: "Location",
                                value: viewModel.user.location ?? "Not set",
                                color: Color(red: 0.01, green: 0.49, blue: 0.94)
                            )
                            
                            ProfileInfoCard(
                                icon: "creditcard.fill",
                                title: "Insurance",
                                value: viewModel.user.insuranceType.rawValue,
                                color: Color.orange
                            )
                            
                            ProfileInfoCard(
                                icon: "globe",
                                title: "Language",
                                value: viewModel.user.language.rawValue,
                                color: Color.purple
                            )
                            
                            if let age = viewModel.user.age {
                                ProfileInfoCard(
                                    icon: "calendar",
                                    title: "Age",
                                    value: "\(age) years",
                                    color: Color(red: 0.22, green: 0.83, blue: 0.62)
                                )
                            }
                            
                            if let gender = viewModel.user.gender {
                                ProfileInfoCard(
                                    icon: "person.fill",
                                    title: "Gender",
                                    value: gender.rawValue,
                                    color: Color.pink
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Edit Profile Button
                        NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Edit Profile")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.01, green: 0.49, blue: 0.94))
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 24)
                        
                        // Settings Section
                        VStack(spacing: 12) {
                            SettingsRow(icon: "lock.shield.fill", title: "Privacy & Security", color: Color.green)
                            SettingsRow(icon: "bell.fill", title: "Notifications", color: Color.orange)
                            SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: Color.blue)
                            SettingsRow(icon: "info.circle.fill", title: "About RespiCheck", color: Color.purple)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        
                        // Danger Zone
                        Button(action: {
                            viewModel.clearUserData()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16))
                                Text("Clear All Data")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 32)
                
                Text(title)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section("Location") {
                TextField("ZIP Code or City", text: $viewModel.manualLocation)
                
                Button("Use Current Location") {
                    viewModel.requestLocationPermission()
                    viewModel.getCurrentLocation()
                }
            }
            
            Section("Insurance") {
                Picker("Type", selection: $viewModel.user.insuranceType) {
                    ForEach(UserModel.InsuranceType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            Section("Language") {
                Picker("Preferred Language", selection: $viewModel.user.language) {
                    ForEach(UserModel.AppLanguage.allCases, id: \.self) { lang in
                        Text(lang.rawValue).tag(lang)
                    }
                }
            }
            
            Section("Demographics (Optional)") {
                TextField("Age", value: $viewModel.user.age, format: .number)
                    .keyboardType(.numberPad)
                
                Picker("Gender", selection: $viewModel.user.gender) {
                    Text("Select").tag(nil as UserModel.Gender?)
                    ForEach(UserModel.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender as UserModel.Gender?)
                    }
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveUserData()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: UserViewModel())
}

