//
// MessageScreenView.swift
// TapOut
//

import SwiftUI

struct MessageScreenView: View {
    
    var message: String
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("scrollSpeed") private var scrollSpeed: Double = 6
    @AppStorage("textSize") private var textSize: Double = 80
    
    @State private var xOffset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            GeometryReader { geo in
                let screenWidth = geo.size.width
                
                HStack(spacing: 50) {
                    Text(message)
                        .font(.system(size: textSize, weight: .heavy))
                        .foregroundColor(.orange)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .background(WidthGetter(width: $textWidth))
                    
                    Text(message)
                        .font(.system(size: textSize, weight: .heavy))
                        .foregroundColor(.orange)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .offset(x: xOffset)
                .onAppear {
                    // Start at center
                    xOffset = 0
                    
                    // Animate continuously
                    let totalDistance = textWidth + 50
                    withAnimation(
                        Animation.linear(duration: scrollSpeed)
                            .repeatForever(autoreverses: false)
                    ) {
                        xOffset = -totalDistance
                    }
                }
                .frame(width: screenWidth, alignment: .center)
            }
        }
        .onTapGesture {
            dismiss()
        }
    }
}

// Helper to measure Text width dynamically
struct WidthGetter: View {
    @Binding var width: CGFloat
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: WidthKey.self, value: geo.size.width)
        }
        .onPreferenceChange(WidthKey.self) { w in
            width = w
        }
    }
}

struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    MessageScreenView(message: "ANOTHER ROUND")
}
