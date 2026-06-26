//
//  GroupStatsView.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 6/25/26.
//

import SwiftUI


struct GroupStatsView: View {
    
    var tasks: [TaskItem]
    var completedCount: Int { tasks.filter { $0.isCompleted}.count }
    var progress: Double { tasks.isEmpty ? 0 : Double(completedCount)/Double(tasks.count) }
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.2)
                    .foregroundColor(.cyan)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(.cyan)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .bold()
            }//end zstack
            .frame(width: 50, height: 50)
            .padding()
            
            VStack(alignment: .leading) {
                Text("Progress Rings")
                    .font(.headline)
                    .foregroundStyle(.brown)
                Text("\(completedCount) / \(tasks.count)")
                    .font(.title2)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview("GroupStatsView") {
    let sampleTasks: [TaskItem] = [
        TaskItem(title: "Math Homework", isCompleted: true),
        TaskItem(title: "Science Project", isCompleted: false),
        TaskItem(title: "Read Chapter 4", isCompleted: true),
        TaskItem(title: "Write Essay", isCompleted: false)
    ]
    return GroupStatsView(tasks: sampleTasks)
        .padding()
        .previewLayout(.sizeThatFits)
}
