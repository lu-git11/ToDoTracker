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

extension TaskGroup {
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
