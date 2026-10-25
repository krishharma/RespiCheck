//
//  AudioModel.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import Foundation

struct AudioModel: Codable {
    var recordingURL: URL?
    var duration: TimeInterval = 0
    var isRecorded: Bool = false
    var uploadStatus: UploadStatus = .notStarted
    
    enum UploadStatus: String, Codable {
        case notStarted
        case uploading
        case analyzing
        case completed
        case failed
    }
}

struct AssessmentResult: Codable {
    let riskLevel: RiskLevel
    let confidence: Double // 0.0 to 1.0
    let factors: [RiskFactor]
    let timestamp: Date
    
    enum RiskLevel: String, Codable {
        case low = "Low"
        case moderate = "Moderate"
        case high = "High"
        
        var color: String {
            switch self {
            case .low: return "green"
            case .moderate: return "yellow"
            case .high: return "red"
            }
        }
        
        var description: String {
            switch self {
            case .low:
                return "Your symptoms and assessment suggest a low risk for pneumonia. Continue monitoring your symptoms."
            case .moderate:
                return "Your assessment indicates moderate risk. We recommend consulting with a healthcare provider soon."
            case .high:
                return "Your assessment suggests high risk. Please seek medical attention as soon as possible."
            }
        }
    }
    
    struct RiskFactor: Codable, Identifiable {
        let id: UUID
        let name: String
        let severity: String
        let isPresent: Bool
        
        init(id: UUID = UUID(), name: String, severity: String, isPresent: Bool) {
            self.id = id
            self.name = name
            self.severity = severity
            self.isPresent = isPresent
        }
    }
    
    // Mock result for demo
    static func mock(riskLevel: RiskLevel) -> AssessmentResult {
        AssessmentResult(
            riskLevel: riskLevel,
            confidence: 0.85,
            factors: [
                RiskFactor(name: "Symptom Frequency", severity: "Moderate", isPresent: true),
                RiskFactor(name: "Cough Pattern", severity: "Moderate", isPresent: true),
                RiskFactor(name: "Environmental Factors", severity: "Low", isPresent: false)
            ],
            timestamp: Date()
        )
    }
}

