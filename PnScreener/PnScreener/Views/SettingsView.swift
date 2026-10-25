//
//  SettingsView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var showDeleteAlert = false
    @State private var showPrivacyPolicy = false
    @State private var showAbout = false
    @State private var showContact = false
    
    var body: some View {
        Form {
            // Profile Section
            Section {
                NavigationLink(destination: UserInfoView(viewModel: userViewModel, showNextScreen: .constant(false))) {
                    Label("Update Profile", systemImage: "person.circle")
                }
                
                HStack {
                    Label("Language", systemImage: "globe")
                    Spacer()
                    Text(userViewModel.user.language.rawValue)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Location", systemImage: "location.fill")
                    Spacer()
                    Text(userViewModel.user.location ?? "Not set")
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            } header: {
                Text("Profile")
            }
            
            // Privacy Section
            Section {
                Button(action: {
                    showPrivacyPolicy = true
                }) {
                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Label("Delete All Session Data", systemImage: "trash")
                        .foregroundColor(.red)
                }
            } header: {
                Text("Privacy & Data")
            } footer: {
                Text("Your health data is stored locally on your device and is not shared without your consent.")
                    .font(.system(size: 13, design: .rounded))
            }
            
            // Support Section
            Section {
                NavigationLink(destination: ResourcesView()) {
                    Label("Health Resources", systemImage: "book.fill")
                }
                
                Button(action: {
                    showAbout = true
                }) {
                    Label("About RespiCheck", systemImage: "info.circle")
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    showContact = true
                }) {
                    Label("Contact Us", systemImage: "envelope.fill")
                        .foregroundColor(.primary)
                }
                
                Link(destination: URL(string: "https://www.cdc.gov/pneumonia/")!) {
                    Label("CDC Resources", systemImage: "arrow.up.right")
                }
            } header: {
                Text("Help & Support")
            }
            
            // App Info
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text("2025.11.11")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("App Information")
            }
        }
        .navigationTitle("Settings")
        .alert("Delete All Data?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("This will permanently delete all your session data including profile information, survey responses, and recordings. This action cannot be undone.")
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .sheet(isPresented: $showContact) {
            ContactView()
        }
    }
    
    private func deleteAllData() {
        userViewModel.clearUserData()
        // Clear other data stores
        UserDefaults.standard.removeObject(forKey: "surveyData")
        UserDefaults.standard.removeObject(forKey: "audioData")
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Group {
                        PolicySection(
                            title: "Data Collection",
                            content: "RespiCheck collects health information including symptoms, audio recordings of coughs, and demographic data to provide personalized respiratory health assessments."
                        )
                        
                        PolicySection(
                            title: "Data Storage",
                            content: "All data is stored locally on your device. We do not transmit your personal health information to external servers without your explicit consent."
                        )
                        
                        PolicySection(
                            title: "Data Usage",
                            content: "Your data is used solely to: (1) Provide personalized health assessments, (2) Connect you with appropriate healthcare resources, (3) Improve our AI algorithms with anonymized data (only if you opt-in)."
                        )
                        
                        PolicySection(
                            title: "Your Rights",
                            content: "You have the right to: (1) Access your data at any time, (2) Delete your data permanently, (3) Opt-out of any data sharing, (4) Request a copy of your information."
                        )
                        
                        PolicySection(
                            title: "Security",
                            content: "We employ industry-standard security measures to protect your data. However, no method of transmission over the internet is 100% secure."
                        )
                    }
                    
                    Text("Last Updated: November 11, 2025")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 80))
                        .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                    
                    Text("RespiCheck")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    
                    Text("The Last Mile to Care")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("About This App")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                        
                        Text("RespiCheck is an AI-powered respiratory screening tool designed to bridge the gap between symptoms and healthcare access. Our mission is to make respiratory health screening accessible to underserved populations.")
                            .font(.system(size: 15, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("This app uses machine learning to analyze your symptoms and cough patterns, providing a preliminary risk assessment and connecting you with nearby healthcare resources.")
                            .font(.system(size: 15, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Important: This is a screening tool, not a diagnostic device. Always consult with qualified healthcare professionals for medical advice.")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                    .cornerRadius(16)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContactView: View {
    @Environment(\.dismiss) var dismiss
    @State private var message = ""
    @State private var email = ""
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Your Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                } header: {
                    Text("Contact Information")
                }
                
                Section {
                    TextEditor(text: $message)
                        .frame(minHeight: 150)
                } header: {
                    Text("Message")
                } footer: {
                    Text("We'll respond within 24-48 hours")
                }
                
                Section {
                    Button(action: sendMessage) {
                        HStack {
                            Spacer()
                            Text("Send Message")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                            Spacer()
                        }
                    }
                    .disabled(email.isEmpty || message.isEmpty)
                }
            }
            .navigationTitle("Contact Us")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Message Sent", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Thank you for contacting us. We'll get back to you soon!")
            }
        }
    }
    
    private func sendMessage() {
        // In a real app, this would send the message to a server
        // For now, we'll just show a success alert
        showSuccessAlert = true
    }
}

struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            
            Text(content)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(userViewModel: UserViewModel())
    }
}

