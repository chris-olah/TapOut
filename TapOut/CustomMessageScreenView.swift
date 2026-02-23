//
//  CustomMessageView.swift
//  TapOut
//
//  Created by Chris Olah on 2/23/26.
//


//
//  CustomMessageView.swift
//  TapOut
//

import SwiftUI

struct CustomMessageScreenView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var messageText: String = ""
    
    var onSend: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                
                Text("Type Your Message")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Button(action: {
                    let trimmed = messageText
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    guard !trimmed.isEmpty else { return }
                    
                    onSend(trimmed.uppercased())
                    dismiss()
                }) {
                    Text("DISPLAY")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Custom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CustomMessageScreenView { _ in }
}
