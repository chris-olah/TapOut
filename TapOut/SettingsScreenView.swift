//
//  SettingsView.swift
//  TapOut
//
//  Created by Chris Olah on 2/23/26.
//


//
//  SettingsView.swift
//  TapOut
//

import SwiftUI

struct SettingsScreenView: View {
    
    @AppStorage("scrollSpeed") private var scrollSpeed: Double = 4
    @AppStorage("textSize") private var textSize: Double = 80
    
    var body: some View {
        Form {
            
            Section("Scroll Duration") {
                Slider(value: $scrollSpeed, in: 1...10)
                Text(String(format: "%.1f seconds", scrollSpeed))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Section("Text Size") {
                Slider(value: $textSize, in: 40...150)
                Text("\(Int(textSize)) pt")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsScreenView()
}
