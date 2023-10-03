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

    @State private var isEditMode = false

    @State private var isMenuPresented = false

    @State private var languages: Languages = .init(from: .english, to: .russian)

    @State private var isShowCopiedToast = false

    private let bottomSpacerID = UUID().uuidString

    // Speech

    @State private var isRecording = false

    @State private var selectedSpeakLanguage: Language?

    @State private var isMicInput = false

    @StateObject private var speechRecognizer = SpeechRecognizer()

    @State private var isShowingSpeechErrorAlert = false

    @State private var speechError: SpeechRecognizer.E?

    // Services

    @StateObject private var audioPlayer = AudioPlayer()

    private let translateEndpoint = TranslateEndpoint.shared

    private let ud = UserDefaultsManager.shared

    // MARK: - View

    var body: some View {
        let _ = Self._printChanges()

        VStack {
            ChatNavBar(isMenuPresented: $isMenuPresented,
                       isEditMode: $isEditMode,
                       isLanguagesPresented: $isLanguagesPresented,
                       languages: languages)
                .fullScreenCover(isPresented: $isLanguagesPresented) {
                    LanguagesView(languages: $languages)
                }
                .fullScreenCover(isPresented: $isMenuPresented) {
                    SettingsView()
                }

            ScrollViewReader { reader in
                list()
//                    .onChange(of: messages) { _, _ in
//                        reader.scrollTo(bottomSpacerID)
//                    }
            }
            bottomBar()
        }
        .background(Assets.Colors.chatBackground)
        .alert(speechError?.text ?? "", isPresented: $isShowingSpeechErrorAlert) {
            speechAlert()
        }
        .toast(isShow: $isShowCopiedToast)
        .onViewDidLoad {
            languages = ud.languages()
        }
        .onChange(of: languages) { _, newValue in
            ud.saveLanguages(languages: newValue)
        }
    }

    private func list() -> some View {
        List {
            Spacer()
                .frame(height: 1)
                .listRowSeparator(.hidden)
                .listRowBackground(Assets.Colors.chatBackground)
                .id(bottomSpacerID)

            ForEach(0..<messages.count, id: \.self) { i in
                let message = messages[i]

                if i > 0 && !Calendar.current.isDate(message.createdAt, inSameDayAs: messages[i-1].createdAt) {
                    dateCell(message: messages[i-1])
                }

                ChatCell(message: message,
                         isPlaying: message.id == audioPlayer.playingMessageId,
                         onPlay: { play(message: message) },
                         onCopy: { copy(message: message) })
                .flippedUpsideDown()
                .listRowSeparator(.hidden)
                .transition(.slide)
                .id(message.id)

                if i == messages.count - 1 {
                    dateCell(message: messages[i])
                }
            }
        }
        .flippedUpsideDown()
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }

    private func dateCell(message: Message) -> some View {
        DateCell(date: message.createdAt)
            .flippedUpsideDown()
            .listRowSeparator(.hidden)
            .listRowBackground(Assets.Colors.chatBackground)
            .id(message.createdAt)
    }

    @ViewBuilder
    private func bottomBar() -> some View {
        if isMicInput {
            ChatRecordBottomBar(languages: languages,
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
            }
        }
    }

    private func speechAlert() -> some View {
        VStack {
            if let speechError {
                switch speechError {
                case .unknown, .recognizerIsUnavailable:
                    EmptyView()
                case .notAuthorizedToRecognize:
                    Button("Open settings", role: .none) {
                        isShowingSpeechErrorAlert = false
                        openSettings()
                    }
                case .notPermittedToRecord:
                    Button("Open settings", role: .none) {
                        isShowingSpeechErrorAlert = false
                        openSettings()
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                isShowingSpeechErrorAlert = false
            }
        }
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
        } catch {
            speechError = (error as? SpeechRecognizer.E) ?? .unknown
            isShowingSpeechErrorAlert = true
        }
    }

    private func play(message: Message) {
        audioPlayer.play(message: message)
    }

    private func copy(message: Message) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIPasteboard.general.string = message.translation?.text

        isShowCopiedToast = true
    }
}

func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
    }
}
