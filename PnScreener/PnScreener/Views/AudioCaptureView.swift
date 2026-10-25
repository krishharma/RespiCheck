//
//  AudioCaptureView.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct AudioCaptureView: View {
    @ObservedObject var viewModel: AudioAnalyzerViewModel
    @Binding var showNextScreen: Bool
    @State private var showInstructions = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "waveform")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                        .accessibilityHidden(true)
                    
                    Text("Record Your Cough")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)
                
                // Instructions
                if showInstructions {
                    CardView(backgroundColor: Color(red: 0.22, green: 0.71, blue: 1.0).opacity(0.1)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("How to record your cough")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        showInstructions = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .accessibilityLabel("Close instructions")
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                InstructionRow(number: "1", text: "Hold your phone about arm's length away")
                                InstructionRow(number: "2", text: "Press the button below to record")
                                InstructionRow(number: "3", text: "Cough 2-3 times clearly")
                                InstructionRow(number: "4", text: "Press again to stop recording")
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                // Recording Interface
                VStack(spacing: 30) {
                    // Time Display
                    Text(timeString(from: viewModel.recordingTime))
                        .font(.system(size: 48, weight: .light, design: .rounded))
                        .foregroundColor(viewModel.isRecording ? Color.red : .primary)
                        .monospacedDigit()
                        .accessibilityLabel("Recording time: \(Int(viewModel.recordingTime)) seconds")
                    
                    // Waveform Animation
                    WaveformView(isAnimating: viewModel.isRecording)
                        .frame(height: 60)
                    
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
                                .fill(viewModel.isRecording ? Color.red : Color(red: 0.01, green: 0.49, blue: 0.94))
                                .frame(width: 100, height: 100)
                                .shadow(color: viewModel.isRecording ? Color.red.opacity(0.4) : Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.4), radius: 20)
                            
                            Image(systemName: viewModel.isRecording ? "stop.fill" : "mic.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(viewModel.isRecording ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: viewModel.isRecording)
                    }
                    .accessibilityLabel(viewModel.isRecording ? "Stop recording" : "Start recording")
                    .accessibilityHint(viewModel.isRecording ? "Double tap to stop" : "Double tap to start recording")
                    
                    Text(viewModel.isRecording ? "Recording..." : "Ready to Record")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(viewModel.isRecording ? Color.red : .secondary)
                }
                .padding(.vertical, 20)
                
                // Playback Controls
                if viewModel.audioModel.isRecorded {
                    CardView {
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(red: 0.22, green: 0.83, blue: 0.62))
                                    .font(.system(size: 20))
                                
                                Text("Recording saved (\(String(format: "%.1f", viewModel.audioModel.duration))s)")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    viewModel.playRecording()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                        Text(viewModel.isPlaying ? "Playing" : "Listen")
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color(red: 0.22, green: 0.71, blue: 1.0))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                                .accessibilityLabel(viewModel.isPlaying ? "Pause recording" : "Play recording")
                                
                                Button(action: {
                                    viewModel.deleteRecording()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Re-record")
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(Color(red: 0.01, green: 0.49, blue: 0.94))
                                    .cornerRadius(8)
                                }
                                .accessibilityLabel("Delete and re-record")
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                // Submit Button
                CustomButton(
                    "Submit",
                    icon: "arrow.right",
                    style: .primary,
                    isDisabled: !viewModel.audioModel.isRecorded
                ) {
                    viewModel.submitForAnalysis()
                    showNextScreen = true
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .padding()
        }
        .navigationTitle("Audio Recording")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct InstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color(red: 0.01, green: 0.49, blue: 0.94))
                .cornerRadius(14)
            
            Text(text)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        AudioCaptureView(
            viewModel: AudioAnalyzerViewModel(),
            showNextScreen: .constant(false)
        )
    }
}

