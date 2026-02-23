//
//  PresetDisplayView.swift
//  TapOut
//
//  Created by Chris Olah on 2/23/26.
//


import SwiftUI

struct PresetDisplayView: View {
    
    var message: String
    @State private var showFullScreen = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                Text(message)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Button {
                    showFullScreen = true
                } label: {
                    Text("DISPLAY")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 100)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            MessageScreenView(message: message)
        }
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}
