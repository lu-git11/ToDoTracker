//
//  TaskModel.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 6/23/26.
//

import Foundation
import Combine

struct TaskItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct TaskGroup: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var symbolName: String
    var tasks: [TaskItem]
}

struct Profile: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var profileImage: String
    var groups: [TaskGroup]
}

extension TaskGroup {
    var completedCount: Int { tasks.filter { $0.isCompleted}.count }
    var progress: Double { tasks.isEmpty ? 0 : Double(completedCount)/Double(tasks.count)
    }
    static let sampleData: [TaskGroup] = [
        TaskGroup(title: "School",
                  symbolName: "book.fill",
                  tasks: [ TaskItem(title: "Do Homework"),
                           TaskItem(title: " Do Exam")]),
        TaskGroup(title: "Home",
                  symbolName: "house.fill",
                  tasks: [ TaskItem(title: "Cook Dinner"),
                           TaskItem(title: "Clean Room", isCompleted: true)])
    ]
}

extension Profile {
    static let sample: [Profile] = [
        Profile(name: "Professor", profileImage: "professor", groups: TaskGroup.sampleData),
        Profile(name: "Student", profileImage: "student", groups: []),
    ]
}
