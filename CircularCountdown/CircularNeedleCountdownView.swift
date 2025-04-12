//
//  ContentView.swift
//  CircularCountdown
//
//  Created by Rahul Ravi Prakash on 12/04/25.
//

import SwiftUI
import AudioToolbox

struct CircularNeedleCountdownView: View {
    @State private var timeRemaining: Int = 10
    @State private var totalTime: Int = 10
    @State private var timer: Timer? = nil
    @State private var isRunning: Bool = false

    let durationOptions = Array(5...60)

    var progress: Double {
        Double(timeRemaining) / Double(totalTime)
    }

    var angle: Double {
        -progress * 360
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
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 200, height: 200)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(gradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 200, height: 200)
                    .animation(.linear(duration: 1), value: timeRemaining)

                Rectangle()
                    .fill(gradient)
                    .frame(width: 3, height: 90)
                    .offset(y: -45)
                    .rotationEffect(.degrees(-angle))
                    .animation(.linear(duration: 1), value: timeRemaining)

                Circle()
                    .fill(Color.teal)
                    .frame(width: 12, height: 12)

                Text("\(timeRemaining)s")
                    .font(.title)
                    .bold()
            }

            // Picker to select duration
            Picker("Duration", selection: Binding(
                get: { totalTime },
                set: {
                    totalTime = $0
                    timeRemaining = $0
                }
            )) {
                ForEach(durationOptions, id: \.self) { sec in
                    Text("\(sec) sec").tag(sec)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 100)
            .disabled(isRunning)

            // Controls
            HStack(spacing: 40) {
                // Play/Pause
                Button(action: {
                    isRunning ? pauseTimer() : startTimer()
                }) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.teal)
                }

                // Reset
                Button(action: {
                    resetTimer()
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding()
    }

    func startTimer() {
        if timeRemaining <= 0 {
            timeRemaining = totalTime
        }

        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                playCompletionSound()
                pauseTimer()
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func resetTimer() {
        pauseTimer()
        timeRemaining = totalTime
    }
    
    func playCompletionSound() {
        AudioServicesPlaySystemSound(SystemSoundID(1005)) // iPhone "new mail" sound
    }

}

#Preview {
    CircularNeedleCountdownView()
}

