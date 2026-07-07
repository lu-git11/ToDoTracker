//
//  BackgroundColor.swift
//  ToDoTracker
//
//  Created by jeffrey lullen on 6/29/26.
//


import SwiftUI

struct BackgroundColor: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            
            Circle()
                .fill(.purple.opacity(0.18))
                .frame(width: 280, height: 280)
                .blur(radius: 70)
                .offset(x: -130, y: -260)

            Circle()
                .fill(.blue.opacity(0.16))
                .frame(width: 260, height: 260)
                .blur(radius: 75)
                .offset(x: 150, y: -60)

            Circle()
                .fill(.pink.opacity(0.14))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -110, y: 240)

            Circle()
                .fill(.mint.opacity(0.14))
                .frame(width: 240, height: 240)
                .blur(radius: 70)
                .offset(x: 160, y: 420)
        }
        .ignoresSafeArea()
    }
}

//project file - info tab
// Project - TODOTracker
//add language in localization
//localizable file should appear with the language added
// product - export localizations - to desktop or anywhere
// right click on xcloc file - show package contents
//open localized contents
//open xliff file
// copy contents of this file
//paste in AI, translate to language without changing the format of the file
//" generate the russins xliff translation of this file, dont chnage the structure of the original file"
//copy and paste in the xliff file, save
//product - import localiztion
// select the file of languageh
//everything should show

