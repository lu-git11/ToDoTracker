//
//  ContentView.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 6/23/26.
//

import SwiftUI

struct ContentView: View {
    @State private var taskGroups : [TaskGroup] = []  //= TaskGroup.sampleData
    @State private var selectedGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var isShowingAddGroup = false
    @Environment(\.scenePhase) private var scenePhase
    
    let saveKey = "savedTaskGroupsKey"
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedGroup) {
                ForEach(taskGroups) { group in
                    NavigationLink(value: group) {
                        HStack(spacing: 12) {
                            Image(systemName: group.symbolName)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(group.title).fontWeight(.medium)
                                Text("\(group.completedCount)/\(group.tasks.count) done")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            ProgressRingView(progress: group.progress, lineWidth: 5)
                                .frame(width: 22, height: 22)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("TO DO TRACKER")
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .background{
                ZStack {
                    BackgroundColor()
                    Rectangle().fill(.ultraThinMaterial)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddGroup = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            } detail: {
                ZStack {
                    BackgroundColor()
                    if let group = selectedGroup {
                        if let index = taskGroups.firstIndex(where: { $0.id == group.id}) {
                            TaskDetailView(group: $taskGroups[index])
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding()
                        }
                    } else {
                        ContentUnavailableView {
                            Label("No Group Selected", systemImage: "checklist")
                                .symbolEffect(.pulse)
                        } description: {
                            Text("Pick a group from the sidebar, or create a new one.")
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddGroup) {
                NewGroupView { newGroup in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)){
                        taskGroups.append(newGroup)
                        selectedGroup = newGroup
                    }
                }
            }
            .onAppear() {
                loadData()
            }
            .onChange(of: scenePhase) {oldValue, newValue in
                if newValue == .active {
                    print("User is active")
                } else if newValue == .inactive {
                    print("User is away")
                } else if newValue == .background {
                    saveData()
                }
            }
        }
    
    func saveData() {
        if let encodeData = try? JSONEncoder().encode(taskGroups) {
            UserDefaults.standard.set(encodeData, forKey: saveKey)
        }
    }
    
    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let decodedGroups = try? JSONDecoder().decode([TaskGroup].self, from: savedData) {
                taskGroups = decodedGroups
                return
            }
        }
        taskGroups = TaskGroup.sampleData
    }
}

#Preview("Sample Data") {
    // Ensure no saved data interferes with the preview
    UserDefaults.standard.removeObject(forKey: "savedTaskGroupsKey")
    return ContentView()
}
