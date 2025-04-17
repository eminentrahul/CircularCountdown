//
//  SpaghettiConfettiView.swift
//  CircularCountdown
//
//  Created by Rahul Ravi Prakash on 12/04/25.
//

import SwiftUI

struct SpaghettiConfettiView: View {
    var count: Int = 100
    var colors: [Color] = [Color.teal, Color.green, Color.cyan]
    var animate: Bool

    var body: some View {
        ZStack {
            if animate {
                ForEach(0..<count, id: \.self) { i in
                    ConfettiPiece(index: i, color: colors.randomElement()!)
                }
            }
        }
        .transition(.opacity)
    }

    struct ConfettiPiece: View {
        var index: Int
        var color: Color

        @State private var randomX: CGFloat = .zero
        @State private var randomY: CGFloat = .zero
        @State private var rotate: Double = 0

        var body: some View {
            Rectangle()
                .fill(color)
                .frame(width: 4, height: CGFloat.random(in: 10...20))
                .rotationEffect(.degrees(rotate))
                .position(x: randomX, y: randomY)
                .onAppear {
                    withAnimation(Animation.spring(response: 1, dampingFraction: 0.5).delay(Double(index) * 0.015)) {
                        randomX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                        randomY = CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        rotate = Double.random(in: 0...720)
                    }
                }
        }
    }
}

