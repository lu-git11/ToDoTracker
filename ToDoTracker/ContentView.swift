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
                        Label(group.title, systemImage: group.symbolName)
                    }
                }
            }
            .background(Color.blue.opacity(0.4))
            .navigationTitle("TO DO TRACKER")
            .listStyle(.sidebar)
            .toolbar {
                Button {
                    isShowingAddGroup = true
                }  label: {
                    Image(systemName: "plus")
                }
            }
        } detail: {
            if let group = selectedGroup {
                if let index = taskGroups.firstIndex(where: { $0.id == group.id}) {
                    TaskDetailView(group: $taskGroups[index])
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                }
            } else {
                ContentUnavailableView("Select a group", systemImage: "sidebar.left")
                    .background(Color.gray.opacity(0.1))
            }
        }
        .sheet(isPresented: $isShowingAddGroup) {
            NewGroupView { newGroup in
                taskGroups.append(newGroup)
                selectedGroup = newGroup
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

//#Preview {
//    ContentView(taskGroups: TaskGroup.sampleData)
//}
