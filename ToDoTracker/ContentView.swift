//
//  ContentView.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 6/23/26.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @Binding var profile: Profile
    @State private var taskGroups : [TaskGroup] = []  //= TaskGroup.sampleData
    @State private var selectedGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var isShowingAddGroup = false
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var isDrawing = false
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    
    let saveKey = "savedTaskGroupsKey"
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedGroup) {
                ForEach(profile.groups) { group in
                    NavigationLink(value: group) {
                        HStack(spacing: 20) {
                            Image(systemName: group.symbolName)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 35, height: 35)
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
            .navigationTitle(profile.name)
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .background{
                ZStack {
                    BackgroundColor()
                    Rectangle().fill(.ultraThinMaterial)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Circle().fill(Color.primary.opacity(0.1)))
                    }
                }
                
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
                if isDrawing {
                    CanvasView(canvasView: $canvasView, toolPicker: toolPicker)
                } else if let group = selectedGroup {
                    if let index = profile.groups.firstIndex(where: { $0.id == group.id}) {
                        TaskDetailView(group: $profile.groups[index])
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
            .toolbar {
                if selectedGroup != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isDrawing.toggle()
                        } label: {
                            Image(systemName: "pencil.tip.crop.circle")
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isShowingAddGroup) {
            NewGroupView { newGroup in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)){
                    profile.groups.append(newGroup)
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
        if let encodeData = try? JSONEncoder().encode(profile.groups) {
            UserDefaults.standard.set(encodeData, forKey: saveKey)
        }
    }
    
    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let decodedGroups = try? JSONDecoder().decode([TaskGroup].self, from: savedData) {
                profile.groups = decodedGroups
                return
            }
        }
        if profile.groups.isEmpty {
            profile.groups = TaskGroup.sampleData
        }
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var toolPicker: PKToolPicker
    
    func makeUIView(context: Context) -> PKCanvasView {
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
            return canvasView
        }
        canvasView.delegate = context.coordinator
        return canvasView
    }
    
    func updateUIView(_ UIView:PKCanvasView, context:Context) {
        DispatchQueue.main.async {
            toolPicker.setVisible(true, forFirstResponder: UIView)
            toolPicker.addObserver(UIView)
            UIView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        
        init(_ parent: CanvasView) {
            self.parent = parent
        }
    }
}

#Preview("Sample Data") {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var profile = Profile(name: "Sample User", profileImage: "", groups: TaskGroup.sampleData)

    var body: some View {
        // Ensure no saved data interferes with the preview
        ContentView(profile: $profile)
            .onAppear {
                UserDefaults.standard.removeObject(forKey: "savedTaskGroupsKey")
            }
    }
}
