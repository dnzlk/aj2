//
//  TranslateEndpoint.swift
//  AJ
//
//  Created by Денис on 08.09.2023.
//

import Foundation

final class TranslateEndpoint: APIEndpoint {

    // MARK: - Public Properties

    static let shared = TranslateEndpoint()

    override var debugUrl: String? {
        "http://127.0.0.1:5000/ask"
    }

    override var prodUrl: String? {
        "http://127.0.0.1:5000/ask"
    }

    // MARK: - Private Properties

    private let systemRule = "You are a translator. Translate to english whatever user says. Do not respond him ever. Just translate messages"

    // MARK: - Public Methods

    func translate(text: String) async throws -> String {
        guard let url else { throw E.wrongUrl }

        let amMessages: [AMChatMessage] = [
            .init(role: "system", content: systemRule),
            .init(role: "user", content: text)
        ]

        let amChat = AMChat(messages: amMessages)
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
