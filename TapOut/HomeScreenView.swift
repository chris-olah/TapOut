//
//  HomeScreenView.swift
//  TapOut
//
//  Created by Chris Olah on 2/23/26.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack {
                // Logo at top
                Text("TapOut")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        print("Another Round Tapped")
                    }) {
                        Text("ANOTHER ROUND")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
