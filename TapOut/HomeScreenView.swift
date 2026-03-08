// HomeScreenView.swift
// TapOut – Silent Bar Signals
//
// Core functionality: tap a phrase button → shows it full-screen in massive text
// so bartenders can read it across a loud, dark bar.

import SwiftUI

// MARK: - Phrase Model

struct Phrase: Identifiable {
    let id = UUID()
    let text: String
    let emoji: String
}

// MARK: - Data

extension Phrase {
    static let all: [Phrase] = [
        Phrase(text: "CHECK PLEASE",    emoji: "🧾"),
        Phrase(text: "ANOTHER ROUND",   emoji: "🍺"),
        Phrase(text: "WATER PLEASE",    emoji: "💧"),
        Phrase(text: "MENU PLEASE",     emoji: "📋"),
        Phrase(text: "THANK YOU!",      emoji: "🙏"),
        Phrase(text: "ONE MORE MINUTE", emoji: "✋"),
    ]
}

// MARK: - Root View

struct HomeScreenView: View {
    @State private var selectedPhrase: Phrase? = nil
    @State private var showingCustomInput = false
    @State private var customText = ""

    var body: some View {
        ZStack {
            if let phrase = selectedPhrase {
                DisplayView(phrase: phrase) {
                    selectedPhrase = nil
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                PhraseGridView(
                    onSelect: { phrase in selectedPhrase = phrase },
                    onCustom: { showingCustomInput = true }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selectedPhrase?.id)
        // Keep screen on while displaying a phrase
        .onChange(of: selectedPhrase?.id) { _, newVal in
            UIApplication.shared.isIdleTimerDisabled = (newVal != nil)
        }
        .sheet(isPresented: $showingCustomInput) {
            CustomMessageSheet(customText: $customText) { submitted in
                if !submitted.isEmpty {
                    selectedPhrase = Phrase(text: submitted.uppercased(), emoji: "✏️")
                }
                showingCustomInput = false
                customText = ""
            }
        }
    }
}

// MARK: - Phrase Grid (Home Screen)

struct PhraseGridView: View {
    let onSelect: (Phrase) -> Void
    let onCustom: () -> Void

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 4) {
                        Text("TAPOUT")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(8)

                        Text("tap a phrase · hold up to the bartender")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                            .tracking(1)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 28)

                    // Phrase grid
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(Phrase.all) { phrase in
                            PhraseButton(phrase: phrase) {
                                onSelect(phrase)
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    // Custom message button
                    Button(action: onCustom) {
                        HStack(spacing: 10) {
                            Text("✏️")
                                .font(.system(size: 22))
                            Text("CUSTOM MESSAGE")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .tracking(1)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.top, 14)

                    Spacer()
                }
            }
        }
    }
}

// MARK: - Individual Phrase Button

struct PhraseButton: View {
    let phrase: Phrase
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text(phrase.emoji)
                    .font(.system(size: 36))

                Text(phrase.text)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .tracking(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.94 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Full-Screen Display View

struct DisplayView: View {
    let phrase: Phrase
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text(phrase.emoji)
                    .font(.system(size: 80))

                Text(phrase.text)
                    .font(.system(size: dynamicFontSize(for: phrase.text),
                                  weight: .black,
                                  design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.4)
                    .padding(.horizontal, 24)
            }

            // Tap anywhere to dismiss
            VStack {
                Spacer()
                Text("TAP ANYWHERE TO GO BACK")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
                    .tracking(2)
                    .padding(.bottom, 40)
            }
        }
        .onTapGesture {
            onDismiss()
        }
        .gesture(
            DragGesture(minimumDistance: 60, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height > 60 {
                        onDismiss()
                    }
                }
        )
    }

    /// Scales font size based on phrase length so it always fills the screen
    private func dynamicFontSize(for text: String) -> CGFloat {
        switch text.count {
        case ..<8:    return 96
        case 8..<12:  return 80
        case 12..<16: return 68
        default:      return 56
        }
    }
}

// MARK: - Custom Message Sheet

struct CustomMessageSheet: View {
    @Binding var customText: String
    let onSubmit: (String) -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 28) {
                // Handle bar
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)

                VStack(spacing: 6) {
                    Text("CUSTOM MESSAGE")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(4)

                    Text("type what you want to show the bartender")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }

                // Text input
                TextField("e.g. Can I close my tab?", text: $customText)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .tint(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)
                    .focused($isFocused)
                    .onSubmit { onSubmit(customText) }

                // Show It button
                Button {
                    onSubmit(customText)
                } label: {
                    Text("SHOW IT")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                        .tracking(3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .disabled(customText.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(customText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.3 : 1.0)

                Spacer()
            }
        }
        .onAppear { isFocused = true }
    }
}

// MARK: - Preview

#Preview {
    HomeScreenView()
}
