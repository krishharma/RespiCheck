//
//  VoiceAnalyzerView.swift
//  PnScreener
//
//  Standalone voice analyzer with clean UI
//

import SwiftUI

struct VoiceAnalyzerView: View {
    @StateObject private var viewModel = AudioAnalyzerViewModel()
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 0.98)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "waveform")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.22, green: 0.83, blue: 0.62),
                                            Color(red: 0.22, green: 0.71, blue: 1.0)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .padding(.top, 30)
                            
                            VStack(spacing: 8) {
                                Text("Voice Analyzer")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                
                                Text("Record your cough for AI analysis")
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Instructions Card
                        if !viewModel.audioModel.isRecorded {
                            InstructionsCard()
                                .padding(.horizontal, 24)
                        }
                        
                        // Recording Interface
                        RecordingInterfaceCard(viewModel: viewModel)
                            .padding(.horizontal, 24)
                        
                        // Saved Recording
                        if viewModel.audioModel.isRecorded {
                            SavedRecordingCard(viewModel: viewModel)
                                .padding(.horizontal, 24)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Submit Button
                        if viewModel.audioModel.isRecorded {
                            Button(action: {
                                viewModel.submitForAnalysis()
                                showResults = true
                            }) {
                                HStack(spacing: 12) {
                                    Text("Analyze Recording")
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
                                            Color(red: 0.22, green: 0.83, blue: 0.62),
                                            Color(red: 0.22, green: 0.71, blue: 1.0)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color(red: 0.22, green: 0.83, blue: 0.62).opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .padding(.horizontal, 24)
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.audioModel.isRecorded)
        }
    }
}

struct InstructionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color(red: 0.22, green: 0.71, blue: 1.0))
                
                Text("How to Record")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                InstructionStep(number: "1", text: "Hold phone 6-12 inches from your mouth")
                InstructionStep(number: "2", text: "Press the record button below")
                InstructionStep(number: "3", text: "Cough naturally 2-3 times")
                InstructionStep(number: "4", text: "Press stop when finished")
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct InstructionStep: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color(red: 0.22, green: 0.71, blue: 1.0))
                .cornerRadius(14)
            
            Text(text)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct RecordingInterfaceCard: View {
    @ObservedObject var viewModel: AudioAnalyzerViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Timer
            Text(timeString(from: viewModel.recordingTime))
                .font(.system(size: 56, weight: .thin, design: .rounded))
                .foregroundColor(viewModel.isRecording ? Color.red : .primary)
                .monospacedDigit()
            
            // Waveform
            WaveformView(
                isAnimating: viewModel.isRecording,
                color: viewModel.isRecording ? Color.red : Color(red: 0.22, green: 0.71, blue: 1.0)
            )
            .frame(height: 80)
            .padding(.horizontal, 20)
            
            // Record Button
            Button(action: {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                } else {
                    viewModel.startRecording()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(viewModel.isRecording ? Color.red : Color(red: 0.22, green: 0.83, blue: 0.62))
                        .frame(width: 100, height: 100)
                        .shadow(
                            color: (viewModel.isRecording ? Color.red : Color(red: 0.22, green: 0.83, blue: 0.62)).opacity(0.4),
                            radius: viewModel.isRecording ? 20 : 15,
                            x: 0,
                            y: viewModel.isRecording ? 8 : 6
                        )
                    
                    Image(systemName: viewModel.isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(viewModel.isRecording ? 1.05 : 1.0)
                .animation(
                    viewModel.isRecording ?
                    Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) :
                        .default,
                    value: viewModel.isRecording
                )
            }
            
            Text(viewModel.isRecording ? "Recording..." : "Tap to Record")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(viewModel.isRecording ? Color.red : .secondary)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct SavedRecordingCard: View {
    @ObservedObject var viewModel: AudioAnalyzerViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recording Saved")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                    
                    Text("Duration: \(String(format: "%.1f", viewModel.audioModel.duration))s")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.playRecording()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 16))
                        Text(viewModel.isPlaying ? "Playing" : "Play")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.22, green: 0.71, blue: 1.0))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    withAnimation {
                        viewModel.deleteRecording()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                        Text("Re-record")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.gray.opacity(0.15))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    VoiceAnalyzerView()
}

