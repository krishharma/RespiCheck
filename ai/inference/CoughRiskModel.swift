import Foundation

/// Placeholder interface for on-device cough risk scoring.
///
/// `AudioAnalyzerViewModel` does not call this type. Screening still uses
/// `AssessmentResult.mock(riskLevel: .moderate)`.
struct CoughRiskModel {
    struct Input {
        var recordingURL: URL
        var symptomAnswers: [String: String]
    }

    struct Output {
        /// "Low", "Moderate", or "High"
        var risk: String
        var confidence: Double
    }

    /// Returns nil until `ai/models/CoughRiskClassifier.mlmodel` exists and this method loads it.
    func predict(_ input: Input) -> Output? {
        _ = input
        return nil
    }
}
