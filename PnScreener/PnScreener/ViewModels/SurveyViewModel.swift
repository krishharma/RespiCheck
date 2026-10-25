//
//  SurveyViewModel.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import Foundation
import SwiftUI
import Combine

class SurveyViewModel: ObservableObject {
    @Published var survey = SurveyModel()
    @Published var showNextScreen = false
    
    func answerQuestion(_ response: SurveyModel.SurveyResponse) {
        survey.answerCurrentQuestion(response)
        
        // Auto-advance for simple yes/no questions
        if case .boolean(_) = response {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.nextQuestion()
            }
        } else if case .option(_) = response {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.nextQuestion()
            }
        }
        // For multipleOptions, user must tap Continue button
    }
    
    func nextQuestion() {
        if survey.isComplete {
            showNextScreen = true
            saveSurvey()
        } else {
            survey.nextQuestion()
        }
    }
    
    func previousQuestion() {
        survey.previousQuestion()
    }
    
    func saveSurvey() {
        if let encoded = try? JSONEncoder().encode(survey) {
            UserDefaults.standard.set(encoded, forKey: "surveyData")
        }
    }
    
    func loadSurvey() {
        if let data = UserDefaults.standard.data(forKey: "surveyData"),
           let decoded = try? JSONDecoder().decode(SurveyModel.self, from: data) {
            survey = decoded
        }
    }
    
    func clearSurvey() {
        UserDefaults.standard.removeObject(forKey: "surveyData")
        survey = SurveyModel()
    }
    
    var progress: Double {
        return survey.progress
    }
}

