//
//  ContentView.swift
//  CircularCountdown
//
//  Created by Rahul Ravi Prakash on 12/04/25.
//

import SwiftUI

struct CircularNeedleCountdownView: View {
    @State private var timeRemaining: Int = 10
    @State private var totalTime: Int = 10
    @State private var timer: Timer? = nil
    @State private var isRunning: Bool = false

    var progress: Double {
        Double(timeRemaining) / Double(totalTime)
    }

    var angle: Double {
        -progress * 360 // anticlockwise
    }

    var gradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [Color.teal, Color.green]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
        )
    }

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                // Base Circle
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 200, height: 200)

                // Progress Arc
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(gradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 200, height: 200)
                    .animation(.linear(duration: 1), value: timeRemaining)

                // Needle
                Rectangle()
                    .fill(gradient)
                    .frame(width: 3, height: 90)
                    .offset(y: -45)
                    .rotationEffect(.degrees(angle))
                    .animation(.linear(duration: 1), value: timeRemaining)

                // Center Circle
                Circle()
                    .fill(Color.teal)
                    .frame(width: 12, height: 12)

                // Time Display
                Text("\(timeRemaining)s")
                    .font(.title)
                    .bold()
            }
        }
        .padding()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            pauseTimer()
        }
    }

    func startTimer() {
        pauseTimer()
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                pauseTimer()
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
}

#Preview {
    CircularNeedleCountdownView()
}

