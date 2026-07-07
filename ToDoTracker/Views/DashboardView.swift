//
//  DashboardView.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 7/4/26.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var profiles: [Profile] = Profile.sample
    @State private var path = NavigationPath()
    
    let column = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    VStack (spacing: 40){
                        VStack {
                            Text("Welcome to To Do Tracker")
                                .font(.largeTitle)
                                .textCase(.uppercase)
                                .foregroundColor(.brown)
                                .padding(.top, 40)
                            Text("Who is working today?")
                                .font(.system(size: 24, weight: .bold))
                        }//end vstack
                        LazyVGrid(columns: column, spacing: 25) {
                            ForEach($profiles) { $profile in
                                NavigationLink(value: profile) {
                                    ProfileCardView(profile: profile)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }//end zstack
            .navigationTitle("Home")
            .navigationDestination(for: Profile.self) { selectedProfile in
                if let index = profiles.firstIndex(where: {$0.id == selectedProfile.id}) {
                    ContentView(profile: $profiles[index])
                }
            }
        }
    }
}


struct ProfileCardView: View {
    let profile: Profile
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Image(profile.profileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }//end ZStack
            .frame(width: 100, height: 100)
            Text(profile.name)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.purple)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.gray))
                .shadow(color:Color.green.opacity(0.2), radius: 10, x: 0, y: 15)
        )
    }
}
#Preview("Dashboard") {
    DashboardView()
}

