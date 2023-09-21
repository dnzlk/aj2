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

    private let te = TranslateEndpoint.shared

    private var languages: Languages = (.english, .russian)

    // MARK: - View

    var body: some View {
        VStack {
            ChatNavBar(languages: languages)
                .padding(.horizontal)
                .padding(.vertical, 8)

            ScrollViewReader { reader in

                list()

                Spacer()

                textField(scrollView: reader)
            }
        }
    }

    @ViewBuilder
    private func list() -> some View {
        let _ = Self._printChanges()

        List(messages, id: \.id) { message in
            ChatCell(message: message, style: getStyle(forMessage: message))
                .flippedUpsideDown()
                .listRowSeparator(.hidden)
                .transition(.slide)
        }
        .flippedUpsideDown()
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }

    @ViewBuilder
    private func textField(scrollView: ScrollViewProxy) -> some View {
        HStack {
            TextField("Type here", text: $inputText,  axis: .vertical)
                .lineLimit(3)

            Button {
                send()
                scrollView.scrollTo(messages.first?.id)
            } label: {
                Image(systemName: inputText.isEmpty ? "mic.circle.fill" : "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Assets.Colors.accentColor)
            }
            .contentTransition(.symbolEffect(.replace, options: .speed(2.2)))
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Assets.Colors.solidWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(8)
        .background(Assets.Colors.white)
    }

    // MARK: - Private Methods

    private func send() {

        guard !isTranslating else { return }

        if let message = messages.last, case .failed = message.state {
            context.delete(message)
        }

        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        inputText = ""

        let message = Message(originalText: text, createdAt: Date())
        context.insert(message)

        Task {
            do {
                isTranslating = true

                let translation = try await te.translate(text: text, languages: languages)

                await updateTranslation(message: message, translation: translation)
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
                                        isSentByUser: translation.language == languages.1.rawValue)
            try? context.save()
        }
    }

    private func getStyle(forMessage message: Message) -> ChatCell.Style {
        if message.state == .loading {
            return .loading
        }
        if message.state == .failed {
            return .error
        }
        return message.translation?.isSentByUser == true ? .right : .left
    }
}
