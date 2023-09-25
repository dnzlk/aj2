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

    @Binding var transcription: String

    // MARK: - Private Properties

    @State private var error: SpeechRecognizer.E?

    @State private var selectedLanguage: Language?

    @Environment(\.dismiss) private var dismiss

    @StateObject private var speechRecognizer = SpeechRecognizer()

    // MARK: - View

    var body: some View {
        VStack {
            HStack(spacing: 24) {
                if !(selectedLanguage == languages.to) {
                    flag(language: languages.from)
                }
                if !(selectedLanguage == languages.from) {
                    flag(language: languages.to)
                }
            }
            if let error {
                errorBlock(error: error)
            } else if let selectedLanguage {
                Text(selectedLanguage.speakText)
                    .font(.title2)
            }
        }
    }

    private func flag(language: Language) -> some View {
        Button(action: {Task { await selectLanguage(language: language) }}) {
            Text(language.flag)
                .font(.system(size: 60))
        }
        .transition(.slide.combined(with: .opacity))
    }

    @ViewBuilder
    private func errorBlock(error: SpeechRecognizer.E) -> some View {
        VStack {
            Text(textForError(error: error))
                .font(.title2)

            if error == .notAuthorizedToRecognize {
                Button(action: {
                    // open recognition settings
                    self.error = nil
                }, label: {
                    Text("Open settings")
                })
            } else if error == .notPermittedToRecord {
                Button(action: {
                    // open audio permittion settings
                    self.error = nil
                }, label: {
                    Text("Open settings")
                })
            }
        }
    }

    // MARK: - Private Methods

    private func selectLanguage(language: Language) async {
        withAnimation(.linear(duration: 0.2)) {
            selectedLanguage = language
        }

        do {
            await speechRecognizer.resetTranscript()
            try await speechRecognizer.startTranscribing(locale: language.locale)
        } catch let e as SpeechRecognizer.E {
            self.error = e
        } catch {
            self.error = .unknown
        }
    }

    private func stop() async {
        await speechRecognizer.stopTranscribing()
        transcription = speechRecognizer.transcript
        dismiss()
    }

    private func cancel() async {
        await speechRecognizer.stopTranscribing()
        dismiss()
    }

    private func textForError(error: SpeechRecognizer.E) -> String {
        switch error {
        case .unknown, .recognizerIsUnavailable:
            return "Language is not supported"
        case .notAuthorizedToRecognize:
            return "Allow Speech Recognition in Settings"
        case .notPermittedToRecord:
            return "Allow Recording in Settings"
        }
    }
}

#Preview {
    @State var text = ""
    return RecordingView(languages: .init(from: .french, to: .english), transcription: $text)
}
