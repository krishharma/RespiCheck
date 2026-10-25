//
//  SurveyModel.swift
//  PnScreener
//
//  Research-validated symptom questions (CDC, WHO, ATS, IDSA)
//

import Foundation

struct SurveyModel: Codable {
    var responses: [String: SurveyResponse] = [:]
    var currentQuestionIndex: Int = 0
    var emergencySymptoms: Set<String> = []
    
    enum SurveyResponse: Codable {
        case boolean(Bool)
        case option(String)
        case multipleOptions(Set<String>)
        case notAnswered
    }
    
    enum SurveyQuestion: Int, CaseIterable {
        // Section 1: Primary Respiratory
        case hasCough = 0
        case coughProductive = 1
        case shortnessOfBreath = 2
        case chestPain = 3
        case rapidBreathing = 4
        
        // Section 2: Fever and Systemic
        case hasFever = 5
        case hasChills = 6
        case unusualFatigue = 7
        
        // Section 3: Additional Respiratory
        case soreThroat = 8
        case nasalCongestion = 9
        case lostTasteSmell = 10
        
        // Section 4: Systemic Indicators
        case muscleAches = 11
        case headache = 12
        case confusion = 13
        case nauseaVomiting = 14
        
        // Section 5: Emergency Warning Signs
        case emergencySymptoms = 15
        
        // Section 6: Duration and Onset
        case symptomOnset = 16
        case symptomsWorsening = 17
        
        // Section 7: Risk Factors (Optional)
        case riskFactors = 18
        case isOver65 = 19
        case recentExposure = 20
        
        var questionText: String {
            switch self {
            // Section 1
            case .hasCough:
                return "Do you have a cough?"
            case .coughProductive:
                return "Is your cough productive (bringing up mucus or phlegm)?"
            case .shortnessOfBreath:
                return "Are you experiencing shortness of breath or difficulty breathing?"
            case .chestPain:
                return "Do you have chest pain, especially when breathing or coughing?"
            case .rapidBreathing:
                return "Are you experiencing rapid or difficult breathing?"
                
            // Section 2
            case .hasFever:
                return "Do you currently have a fever or have you felt feverish in the past 24-48 hours?"
            case .hasChills:
                return "Have you experienced chills or shaking?"
            case .unusualFatigue:
                return "Are you experiencing unusual fatigue or extreme tiredness?"
                
            // Section 3
            case .soreThroat:
                return "Do you have a sore throat?"
            case .nasalCongestion:
                return "Do you have nasal congestion or a runny nose?"
            case .lostTasteSmell:
                return "Have you lost your sense of taste or smell?"
                
            // Section 4
            case .muscleAches:
                return "Are you experiencing muscle aches or body pain?"
            case .headache:
                return "Do you have a headache?"
            case .confusion:
                return "Have you experienced confusion, disorientation, or unusual difficulty thinking clearly?"
            case .nauseaVomiting:
                return "Have you experienced nausea, vomiting, or diarrhea?"
                
            // Section 5
            case .emergencySymptoms:
                return "Are you experiencing any of these emergency symptoms?"
                
            // Section 6
            case .symptomOnset:
                return "When did your symptoms begin?"
            case .symptomsWorsening:
                return "Have your symptoms been getting worse over time?"
                
            // Section 7
            case .riskFactors:
                return "Do you have any of these medical conditions?"
            case .isOver65:
                return "Are you age 65 or older?"
            case .recentExposure:
                return "Have you been in close contact with someone diagnosed with COVID-19, pneumonia, or another respiratory infection?"
            }
        }
        
        var iconName: String {
            switch self {
            case .hasCough, .coughProductive:
                return "wind"
            case .shortnessOfBreath, .rapidBreathing:
                return "lungs.fill"
            case .chestPain:
                return "heart.text.square"
            case .hasFever:
                return "thermometer.medium"
            case .hasChills:
                return "snowflake"
            case .unusualFatigue:
                return "bed.double.fill"
            case .soreThroat:
                return "mouth.fill"
            case .nasalCongestion:
                return "nose.fill"
            case .lostTasteSmell:
                return "eye.slash.fill"
            case .muscleAches:
                return "figure.walk"
            case .headache:
                return "brain.head.profile"
            case .confusion:
                return "exclamationmark.triangle.fill"
            case .nauseaVomiting:
                return "cross.circle.fill"
            case .emergencySymptoms:
                return "exclamationmark.octagon.fill"
            case .symptomOnset:
                return "calendar"
            case .symptomsWorsening:
                return "chart.line.uptrend.xyaxis"
            case .riskFactors:
                return "cross.case.fill"
            case .isOver65:
                return "person.fill"
            case .recentExposure:
                return "person.2.fill"
            }
        }
        
        var questionType: QuestionType {
            switch self {
            case .hasCough, .shortnessOfBreath, .chestPain, .rapidBreathing,
                 .hasChills, .unusualFatigue, .soreThroat, .nasalCongestion,
                 .lostTasteSmell, .muscleAches, .headache, .confusion,
                 .nauseaVomiting, .symptomsWorsening, .isOver65:
                return .yesNo
                
            case .coughProductive, .hasFever, .recentExposure:
                return .yesNoNotSure
                
            case .emergencySymptoms:
                return .multipleSelect(options: [
                    "Persistent pressure or pain in chest",
                    "Bluish lips or face",
                    "Inability to stay awake or extreme drowsiness",
                    "Severe or worsening shortness of breath",
                    "Coughing up blood",
                    "None of the above"
                ])
                
            case .symptomOnset:
                return .singleChoice(options: [
                    "Today",
                    "1-2 days ago",
                    "3-7 days ago",
                    "More than a week ago"
                ])
                
            case .riskFactors:
                return .multipleSelect(options: [
                    "Asthma or chronic lung disease",
                    "Heart disease",
                    "Diabetes",
                    "Weakened immune system",
                    "Current smoker",
                    "None of the above"
                ])
            }
        }
        
        var isOptional: Bool {
            switch self {
            case .riskFactors, .isOver65, .recentExposure:
                return true
            default:
                return false
            }
        }
        
        var shouldSkip: Bool {
            // Skip coughProductive if they don't have a cough
            return false // Will be handled by logic
        }
    }
    
    enum QuestionType {
        case yesNo
        case yesNoNotSure
        case singleChoice(options: [String])
        case multipleSelect(options: [String])
    }
    
    var isComplete: Bool {
        return currentQuestionIndex >= SurveyQuestion.allCases.count
    }
    
    var currentQuestion: SurveyQuestion? {
        guard currentQuestionIndex < SurveyQuestion.allCases.count else { return nil }
        return SurveyQuestion.allCases[currentQuestionIndex]
    }
    
    var hasEmergencySymptoms: Bool {
        if case .multipleOptions(let symptoms) = responses["emergencySymptoms"] {
            return !symptoms.isEmpty && !symptoms.contains("None of the above")
        }
        return false
    }
    
    mutating func answerCurrentQuestion(_ response: SurveyResponse) {
        guard let question = currentQuestion else { return }
        responses[question.questionText] = response
    }
    
    mutating func nextQuestion() {
        currentQuestionIndex += 1
        
        // Skip coughProductive if they don't have a cough
        if currentQuestionIndex == 1, // coughProductive index
           case .boolean(false)? = responses["Do you have a cough?"] {
            currentQuestionIndex += 1
        }
    }
    
    mutating func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            
            // Skip back over coughProductive if needed
            if currentQuestionIndex == 1,
               case .boolean(false)? = responses["Do you have a cough?"] {
                currentQuestionIndex -= 1
            }
        }
    }
    
    var progress: Double {
        let total = Double(SurveyQuestion.allCases.count)
        return Double(currentQuestionIndex) / total
    }
}

