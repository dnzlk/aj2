//
//  TranslateEndpoint.swift
//  AJ
//
//  Created by Денис on 08.09.2023.
//

import Foundation

struct AMChat: Codable {

    let messages: [AMChatMessage]
}

struct Translation {

    let text: String
    let language: String?
}

final class TranslateEndpoint: APIEndpoint {

    // MARK: - Public Properties

    static let shared = TranslateEndpoint()

    override var debugUrl: String? {
        "http://127.0.0.1:5000/ask"
    }

    override var prodUrl: String? {
        "http://127.0.0.1:5000/ask"
    }

    // MARK: - Public Methods

    func translate(text: String, languages: Languages) async throws -> Translation {
        guard let url else { throw E.wrongUrl }

        let amMessages: [AMChatMessage] = [
            .init(role: "system", content: generateSystemRule(languages: languages)),
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

        let decodedResponse = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = decodedResponse.components(separatedBy: ";")
        let code = parts.first

        return Translation(text: String(decodedResponse.dropFirst((code?.count ?? -1) + 1)), language: code?.lowercased())
    }

    // MARK: - Private Methods

    private func generateSystemRule(languages: Languages) -> String {
        return """
                "You are a translator between \(languages.0) and \(languages.1). You will be given a message in one of them. You must detect the language of the message and translate it to the second language. At the beginning of the translation add the ISO 639-1 code of the message language and ; symbol. Do not respond anything else."
            """
    }
}
