//
//  HomeScreenView.swift
//  TapOut
//
//  Created by Chris Olah on 2/23/26.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var selectedMessage: String? = nil
    @State private var showingCustomMessage = false
    
    let quickMessages = [
        "ANOTHER ROUND",
        "CHECK PLEASE",
        "WATER PLEASE"
    ]
    
    var body: some View {
        NavigationStack {
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
                            selectedMessage = "ANOTHER ROUND"
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

                    VStack(spacing: 20) {
                        Button(action: {
                            selectedMessage = "CHECK PLEASE"
                        }) {
                            Text("CHECK PLEASE")
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

                    VStack(spacing: 20) {
                        Button(action: {
                            selectedMessage = "WATER PLEASE"
                        }) {
                            Text("WATER PLEASE")
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
                    
                    // Custom Message Button
                    Button(action: {
                        showingCustomMessage = true
                    }) {
                        Text("CUSTOM MESSAGE")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .toolbar {
                NavigationLink(destination: SettingsScreenView()) {
                    Image(systemName: "gearshape.fill").foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showingCustomMessage) {
                CustomMessageScreenView { message in
                    selectedMessage = message
                }
            }
            .fullScreenCover(item: $selectedMessage) { message in MessageScreenView(message: message)
            }
        }
    }
}

// Allows String to work with fullScreenCover
extension String: Identifiable {
    public var id: String { self }
}

#Preview {
    HomeScreenView()
}
