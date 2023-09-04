//
//  CharactersService.swift
//  AskJoe
//
//  Created by Денис on 18.03.2023.
//

import Foundation

final class CharactersEndpoint: APIEndpoint {

    // MARK: - Public Properties

    static let shared = CharactersEndpoint()

    override var debugUrl: String? {
        "https://chatbot-ios-backend-test.vercel.app/v1/characters"
    }

    override var prodUrl: String? {
        "https://chatbot-ios-backend.vercel.app/v1/characters"
    }

    // MARK: - Public Methods

    func load() async throws -> [Person] {
        guard let url else { throw E.wrongUrl }

        let (data, _) = try await URLSession.shared.data(from: url)
        let amPeople = try JSONDecoder().decode([AMCharactersResponse].self, from: data)

        return amPeople.compactMap { $0.person() }
    }
}
