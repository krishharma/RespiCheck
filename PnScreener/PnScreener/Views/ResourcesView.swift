//
//  ResourcesView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct ResourcesView: View {
    @State private var selectedResource: EducationalResource?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                        .accessibilityHidden(true)
                    
                    Text("Health Resources")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Text("Learn more about respiratory health")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Educational Cards
                VStack(spacing: 16) {
                    ForEach(EducationalResource.allResources) { resource in
                        ExpandableCard(
                            title: resource.title,
                            icon: resource.icon,
                            content: resource.content
                        )
                    }
                }
                
                // Deep Breathing Exercise
                CardView(backgroundColor: Color(red: 0.22, green: 0.83, blue: 0.62).opacity(0.1)) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "wind")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                            
                            Text("Did you know?")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        
                        Text("Deep breathing exercises can help improve lung capacity and reduce stress. Try taking 5 slow, deep breaths each morning.")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // External Resources
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trusted Health Resources")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        
                        ForEach(ExternalLink.allLinks) { link in
                            ExternalLinkRow(link: link)
                        }
                    }
                }
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("Resources")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EducationalResource: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let content: String
    
    static let allResources: [EducationalResource] = [
        EducationalResource(
            title: "What is Pneumonia?",
            icon: "info.circle.fill",
            content: "Pneumonia is an infection that inflames the air sacs in one or both lungs. The air sacs may fill with fluid or pus, causing cough with phlegm, fever, chills, and difficulty breathing. Various organisms, including bacteria, viruses, and fungi, can cause pneumonia."
        ),
        EducationalResource(
            title: "Recognizing Symptoms",
            icon: "stethoscope",
            content: "Common symptoms include chest pain when breathing or coughing, confusion (especially in older adults), cough with phlegm, fatigue, fever, sweating and chills, nausea and vomiting, and shortness of breath. Seek immediate medical attention if you experience severe symptoms."
        ),
        EducationalResource(
            title: "Prevention Tips",
            icon: "shield.checkered",
            content: "You can help prevent pneumonia by: getting vaccinated, practicing good hygiene (washing hands regularly), not smoking, maintaining a healthy lifestyle, and managing chronic conditions. Annual flu shots and pneumococcal vaccines are particularly important for high-risk individuals."
        ),
        EducationalResource(
            title: "When to Seek Care",
            icon: "cross.case.fill",
            content: "Seek immediate medical attention if you: have difficulty breathing, experience chest pain, have a persistent fever of 102°F or higher, are coughing up blood, feel confused or disoriented, or belong to a high-risk group (over 65, chronic illness, weakened immune system)."
        ),
        EducationalResource(
            title: "About Your Screening",
            icon: "doc.text.fill",
            content: "This app uses AI to analyze your symptoms and cough patterns to assess pneumonia risk. It's a screening tool designed to help you make informed decisions about seeking medical care. This is NOT a diagnosis and should not replace professional medical advice."
        )
    ]
}

struct ExternalLink: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let url: String
    
    static let allLinks: [ExternalLink] = [
        ExternalLink(
            title: "CDC - Pneumonia Information",
            subtitle: "Centers for Disease Control and Prevention",
            icon: "building.columns.fill",
            url: "https://www.cdc.gov/pneumonia/"
        ),
        ExternalLink(
            title: "WHO - Respiratory Health",
            subtitle: "World Health Organization",
            icon: "globe",
            url: "https://www.who.int/health-topics/pneumonia"
        ),
        ExternalLink(
            title: "American Lung Association",
            subtitle: "Learn about lung health",
            icon: "lungs.fill",
            url: "https://www.lung.org"
        )
    ]
}

struct ExternalLinkRow: View {
    let link: ExternalLink
    
    var body: some View {
        Button(action: {
            if let url = URL(string: link.url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: link.icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.1))
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(link.title)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(link.subtitle)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .accessibilityLabel("\(link.title). Opens in browser")
    }
}

#Preview {
    NavigationStack {
        ResourcesView()
    }
}

