//
//  ProgressRingView.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 6/29/26.
//

import SwiftUI

struct ProgressRingView: View {
    var progress: Double
    var lineWidth: CGFloat = 10
    var ringColor: Color = .cyan
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.2)
                .foregroundColor(ringColor)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(ringColor)
                .rotationEffect(.degrees(-90))
        }
    }
}
