//
//  RecordingView.swift
//  AJ
//
//  Created by Денис on 12.09.2023.
//

import SwiftUI

struct RecordingView: View {

    // MARK: - Public Properties

    let languages: Languages
    @State private var currentLanguage: Language
    @Environment(\.dismiss) private var dismiss

    // MARK: - Private Properties

    @Binding private var transcription: String

    @StateObject private var speechRecognizer = SpeechRecognizer()

    // MARK: - Init

    init(languages: Languages, transcription: Binding<String>) {
        self.languages = languages
        self._transcription = transcription
        self._currentLanguage = State(initialValue: languages.from)
    }

    // MARK: - View

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: cancel) {
                    Text("Cancel")
                }
            }
            .padding(.horizontal)
            .foregroundStyle(Assets.Colors.accentColor)

            Spacer()

            Text("\(currentLanguage.speakText)")
                .font(Font(UIFont.medium(28)))
                .foregroundStyle(.white)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        currentLanguage = languages.to
                    }
                }

            Spacer()

            Image(systemName: "waveform")
                .symbolEffect(.pulse.wholeSymbol,
                              options: .repeating)
                .foregroundStyle(Assets.Colors.accentColor)
                .font(.system(size: 90))

            Spacer()

            Button(action: stop) {
                Image(systemName: "stop.circle")
                    .foregroundStyle(.red)
                    .font(.system(size: 60))
            }

            Spacer()
        }
        .background(Color.black.opacity(0.8))
        .onAppear {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
        }
    }

    // MARK: - Private Methods

    private func stop() {
        speechRecognizer.stopTranscribing()
        transcription = speechRecognizer.transcript
        dismiss()
    }

    private func cancel() {
        speechRecognizer.stopTranscribing()
        dismiss()
    }
}
