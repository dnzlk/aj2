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
        "https://dull-clowns-live.loca.lt/ask"//"http://127.0.0.1:5000/ask"
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

        let decodedResponse = response.content.trmd()
        let parts = decodedResponse.components(separatedBy: ";")
        let code = parts.first
        return Translation(text: String(decodedResponse.dropFirst((code?.count ?? -1) + 1)).trmd(), language: code?.lowercased())
    }

    // MARK: - Private Methods

    private func generateSystemRule(languages: Languages) -> String {
        let _1 = languages.0
        let _2 = languages.1

        return """
                "You must translate the given request between \(_1) and \(_2) languages. Translate to \(_2) if the request is in \(_1), or translate to \(_1) if the request is in \(_2). At the beginning of your response add '\(_2.rawValue);' if the request is in \(_1), or '\(_1.rawValue);' if the request is in \(_2). Do not respond anything else."
            """
    }
}

extension String {

    func trmd() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
