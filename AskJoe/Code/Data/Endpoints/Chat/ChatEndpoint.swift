//
//  ChatService.swift
//  AskJoe
//
//  Created by Денис on 03.03.2023.
//

import Foundation

final class ChatEndpoint: APIEndpoint {

    // MARK: - Types

    private enum Role: String {
        case user
        case assistant
    }

    // MARK: - Public Properties

    static let shared = ChatEndpoint()

    override var debugUrl: String? {
        "https://chatbot-ios-backend-test.vercel.app/chat/chat"
    }

    override var prodUrl: String? {
        "https://chatbot-ios-backend.vercel.app/chat/chat"
    }

    // MARK: - Public Methods

    func ask(request: String, chat: Chat, version: String?) async throws -> String {
        guard let url else { throw E.wrongUrl }

        var amMessages = chat.messages.map {
            AMChatMessage(role: $0.isUserMessage ? Role.user.rawValue : Role.assistant.rawValue,
                          content: $0.text)
        }
        amMessages.append(.init(role: Role.user.rawValue, content: request))

        let amChat = AMChat(characterId: chat.person?.characterId, messages: amMessages, version: version, chatId: chat.chatId)
        let encodedAmChat = try JSONEncoder().encode(amChat)

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedAmChat

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AMChatResponse.self, from: data)

        return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
