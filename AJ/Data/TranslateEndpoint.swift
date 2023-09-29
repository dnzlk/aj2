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

    // MARK: - Types

    enum E: Error {
        case wrongUrl
        case unknownLanguage
    }

    // MARK: - Public Properties

    static let shared = TranslateEndpoint()

    override var debugUrl: String? {
        "http://127.0.0.1:3000/ask"
    }

    override var prodUrl: String? {
        "http://165.232.91.100:80/ask"
    }

    // MARK: - Private Properties

    private let detector = LanguageDetector.shared

    // MARK: - Public Methods

    func translate(text: String, languages: Languages, textLanguage: Language? = nil) async throws -> Translation {
        guard let url else { throw E.wrongUrl }

        guard
            let originalLanguage = textLanguage ?? detector.detectedLanguage(for: text, languages: languages),
            let translateToLanguage = [languages.from, languages.to].first(where: { $0.code != originalLanguage.code} )
        else {
            throw E.unknownLanguage
        }

        let amMessages: [AMChatMessage] = [
            .init(role: "user", content: "Translate from \(originalLanguage.englishName) to \(translateToLanguage.englishName): \(text)")
        ]

        let amChat = AMChat(messages: amMessages)
        let encodedAmChat = try JSONEncoder().encode(amChat)

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedAmChat

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AMChatResponse.self, from: data)

        return Translation(text: response.content.trmd(), language: translateToLanguage.code)
    }
}

extension String {

    func trmd() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
