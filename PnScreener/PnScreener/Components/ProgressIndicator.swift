//
//  ProgressIndicator.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import SwiftUI

struct ProgressIndicator: View {
    let progress: Double // 0.0 to 1.0
    var height: CGFloat = 8
    var accentColor: Color = Color(red: 0.22, green: 0.71, blue: 1.0)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(accentColor)
                    .frame(width: geometry.size.width * CGFloat(progress), height: height)
                    .animation(.easeInOut, value: progress)
            }
        }
        .frame(height: height)
        .accessibilityLabel("Progress: \(Int(progress * 100)) percent")
    }
}

struct LoadingIndicator: View {
    @State private var isAnimating = false
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color(red: 0.01, green: 0.49, blue: 0.94).opacity(0.2), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        Color(red: 0.01, green: 0.49, blue: 0.94),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            .onAppear {
                isAnimating = true
            }
            
            Text(message)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
    }
}

struct WaveformView: View {
    @State private var animationPhase = 0.0
    var isAnimating: Bool = false
    var color: Color = Color(red: 0.22, green: 0.71, blue: 1.0)
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 4)
                    .frame(height: barHeight(for: index))
                    .animation(
                        isAnimating ? 
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.1) : 
                            .default,
                        value: isAnimating
                    )
            }
        }
        .frame(height: 40)
        .accessibilityHidden(true)
    }
    
    private func barHeight(for index: Int) -> CGFloat {
        if isAnimating {
            let heights: [CGFloat] = [12, 24, 40, 24, 12]
            return heights[index]
        }
        return 8
    }
}

#Preview {
    VStack(spacing: 40) {
        ProgressIndicator(progress: 0.6)
            .frame(height: 8)
            .padding(.horizontal)
        
        LoadingIndicator(message: "Analyzing your data...")
        
        WaveformView(isAnimating: true)
    }
    .padding()
}

