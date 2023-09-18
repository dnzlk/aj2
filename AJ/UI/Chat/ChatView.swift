//
//  NewChatView.swift
//  AJ
//
//  Created by Денис on 13.09.2023.
//

import SwiftData
import SwiftUI
import Foundation

struct ChatView: View {

    // MARK: - Private Properties

    @Environment(\.modelContext) private var context

    @Query(sort: \Message.createdAt, order: .reverse) private var messages: [Message]

    @State private var inputText = ""

    private let languages: Languages = (.english, .russian)

    private let te = TranslateEndpoint.shared

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
                    .padding()
            }
        }
    }

    @ViewBuilder
    private func list() -> some View {
        let _ = Self._printChanges()

        List(messages.reversed(), id: \.id) { message in
            ChatCell(message: message,
                     style: getStyle(forMessage: message),
                     isPlaying: false)
            .flippedUpsideDown()
        }
        .flippedUpsideDown()
        .listStyle(.plain)
        .background(.red)
    }

    private func textField(scrollView: ScrollViewProxy) -> some View {
        HStack {
            TextField("Type here", text: $inputText,  axis: .vertical)
                .lineLimit(3)

            Button {
                send(text: inputText)
                scrollView.scrollTo(messages.first?.id)
            } label: {
                Text("Button")
            }
        }
    }

    // MARK: - Private Methods

    private func send(text: String) {
        if let message = messages.last, case .failed = message.state {
            context.delete(message)
        }

        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        FBAnalytics.log(.chat_send_tap)

        inputText = ""

        let message = Message(originalText: text, createdAt: Date())
        context.insert(message)

        Task {

            do {
                let translation = try await te.translate(text: text, languages: languages)

                let translatedMessage = Message(id: message.id,
                                                originalText: message.originalText,
                                                translation: translation.text,
                                                createdAt: message.createdAt,
                                                language: translation.language,
                                                isSentByUser: translation.language == languages.1.rawValue)

                context.insert(translatedMessage)
                pendingMessage = nil
            } catch {
                pendingMessage?.hasFailed = true
                FBAnalytics.log(.chat_error)
            }

        }
    }

    private func getStyle(forMessage message: Message) -> ChatCell.Style {
        if message === pendingMessage?.message {
            return pendingMessage?.hasFailed == true ? .error : .loading
        }
        return message.isSentByUser == true ? .right : .left
    }
}

struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View{
    func flippedUpsideDown() -> some View {
        self.modifier(FlippedUpsideDown())
    }
}

//#Preview {
//
//    ChatView()
//}
