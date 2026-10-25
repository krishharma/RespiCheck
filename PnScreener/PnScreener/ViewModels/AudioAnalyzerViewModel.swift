//
//  AudioAnalyzerViewModel.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

class AudioAnalyzerViewModel: NSObject, ObservableObject {
    @Published var audioModel = AudioModel()
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var recordingTime: TimeInterval = 0
    @Published var showAnalysisScreen = false
    @Published var assessmentResult: AssessmentResult?
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingTimer: Timer?
    
    private let recordingURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("cough_recording.m4a")
    }()
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startRecording() {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            recordingTime = 0
            
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.recordingTime += 0.1
            }
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        recordingTimer?.invalidate()
        isRecording = false
        audioModel.recordingURL = recordingURL
        audioModel.duration = recordingTime
        audioModel.isRecorded = true
    }
    
    func playRecording() {
        guard let url = audioModel.recordingURL else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play recording: \(error)")
        }
    }
    
    func deleteRecording() {
        if let url = audioModel.recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        audioModel = AudioModel()
        recordingTime = 0
    }
    
    func submitForAnalysis() {
        audioModel.uploadStatus = .uploading
        
        // Simulate upload and analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.audioModel.uploadStatus = .analyzing
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                self?.audioModel.uploadStatus = .completed
                // Generate mock result based on symptoms
                self?.assessmentResult = AssessmentResult.mock(riskLevel: .moderate)
                self?.showAnalysisScreen = true
            }
        }
    }
    
    func saveAudioData() {
        if let encoded = try? JSONEncoder().encode(audioModel) {
            UserDefaults.standard.set(encoded, forKey: "audioData")
        }
    }
    
    func clearAudioData() {
        deleteRecording()
        UserDefaults.standard.removeObject(forKey: "audioData")
    }
}

extension AudioAnalyzerViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording failed")
            audioModel.isRecorded = false
        }
    }
}

extension AudioAnalyzerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}

