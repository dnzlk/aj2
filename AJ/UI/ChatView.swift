//
//  NewChatView.swift
//  AJ
//
//  Created by Денис on 13.09.2023.
//

import SwiftData
import SwiftUI

struct ChatView: View {

    // MARK: - Private Properties

    @Environment(\.modelContext) private var context

    @Query(sort: \Message.createdAt, order: .reverse) private var messages: [Message]

    @State private var inputText = ""

    @State private var isTranslating = false

    @State private var isLanguagesPresented = false

    @State private var languages: Languages = .init(from: .english, to: .russian)

    @State private var isShowingCopiedToast = false

    // Speech

    @State private var isRecording = false

    @State private var selectedSpeakLanguage: Language?

    @State private var isMicInput = false

    // Services

    @StateObject private var audioPlayer = AudioPlayer()

    @StateObject private var speechRecognizer = SpeechRecognizer()

    private let translateEndpoint = TranslateEndpoint.shared

    private let ud = UserDefaultsManager.shared

    // MARK: - View

    var body: some View {
        VStack {
            ChatNavBar(isLanguagesPresented: $isLanguagesPresented, languages: languages)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .fullScreenCover(isPresented: $isLanguagesPresented) {
                    LanguagesView(languages: $languages)
                }

            ScrollViewReader { reader in

                list()

                Spacer()

                if isMicInput {
                    ChatVoicesBottomBar(languages: languages,
                                        selectedLanguage: selectedSpeakLanguage,
                                        isRecording: isRecording,
                                        isMicInput: $isMicInput,
                                        onStartRecording: { language in
                        Task { await startRecording(language:language) }
                    },
                                        onSend: {
                        Task { await speechRecognizer.stopTranscribing() }
                        isRecording = false
                        selectedSpeakLanguage = nil
                        send(text: speechRecognizer.transcript)
                    },
                                        onCancel: {
                        Task { await speechRecognizer.stopTranscribing() }
                        isRecording = false
                        selectedSpeakLanguage = nil
                    })
                } else {
                    ChatTextField(inputText: $inputText, isMicInput: $isMicInput) {
                        inputText.isEmpty ?
                        withAnimation {
                            isMicInput = true
                        }
                        : send(text: inputText)
                        reader.scrollTo(messages.first?.id)
                    }
                }
            }
        }
//        .toast(text: "Copied", icon: .init(systemName: "doc.on.doc"), isShowing: $isShowingCopiedToast)
        .onViewDidLoad {
            languages = ud.languages()
        }
        .onChange(of: languages) { _, newValue in
            ud.saveLanguages(languages: newValue)
        }
        .onChange(of: isShowingCopiedToast) { _, newValue in
            guard newValue else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isShowingCopiedToast = false
            }
        }
    }

    @ViewBuilder
    private func list() -> some View {
        let _ = Self._printChanges()

        List(messages, id: \.id) { message in
            ChatCell(message: message,
                     onPlay: { play(message: message) },
                     onCopy: { copy(message: message) })
                .flippedUpsideDown()
                .listRowSeparator(.hidden)
                .transition(.slide)
        }
        .flippedUpsideDown()
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }

    // MARK: - Private Methods

    private func send(text: String) {

        guard !isTranslating else { return }

        if let message = messages.last, case .failed = message.state {
            context.delete(message)
        }

        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        inputText = ""

        let message = Message(originalText: text, createdAt: Date())
        context.insert(message)

        Task {
            do {
                isTranslating = true

                let translation = try await translateEndpoint.translate(text: text, languages: languages)

                updateTranslation(message: message, translation: translation)
            } catch {
                message.error = error.localizedDescription
            }

            isTranslating = false
        }
    }

    @MainActor
    private func updateTranslation(message: Message, translation: Translation) {
        withAnimation {
            message.translation = .init(text: translation.text,
                                        language: translation.language ?? "en",
                                        isSentByUser: translation.language == languages.to.rawValue)
        }
    }

    private func startRecording(language: Language) async {
        do {
            await speechRecognizer.resetTranscript()
            try await speechRecognizer.startTranscribing(locale: language.locale)
            isRecording = true
            selectedSpeakLanguage = language
        } catch let e as SpeechRecognizer.E {
//            self.error = e
        } catch {
//            self.error = .unknown
        }
    }

    private func play(message: Message) {
        audioPlayer.play(message: message)
    }

    private func copy(message: Message) {
        UIPasteboard.general.string = message.translation?.text

        withAnimation {
            isShowingCopiedToast = true
        }
    }
}
