//
//  TaskDetailView.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 6/23/26.
//

import SwiftUI

struct TaskDetailView: View {
    @Binding var group: TaskGroup
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        
        List {
            Section{
                if sizeClass == .regular {
                    GroupStatsView(tasks: group.tasks)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color(.secondarySystemBackground))
                }
            }
            
            ForEach($group.tasks) { $task in
                HStack {
                    Image(systemName: task.isCompleted ?
                          "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .purple : .gray)
                    .onTapGesture {
                        withAnimation {
                            task.isCompleted.toggle()
                        }
                    }
                    TextField("Task Title", text: $task.title)
                        .strikethrough(task.isCompleted)
                        .foregroundStyle(task.isCompleted ? .gray : .primary)
                }//end HStack
            }//end ForEach
            .onDelete { index in
                group.tasks.remove(atOffsets: index)
            }
        }//end List
        .navigationTitle(group.title)
        .toolbar {
            Button("Add Task +") {
                withAnimation{
                    group.tasks.append(TaskItem(title: ""))
                }
            }// end button
        }//end Toolbar
    } // end body
}//end struct
