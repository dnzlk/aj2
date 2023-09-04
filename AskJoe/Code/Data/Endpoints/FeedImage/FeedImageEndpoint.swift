//
//  FeedImageService.swift
//  AskJoe
//
//  Created by Денис on 03.05.2023.
//

import Foundation

final class FeedImageEndpoint: APIEndpoint {

    // MARK: - Public Properties

    override var debugUrl: String? {
        "https://chatbot-ios-backend-test.vercel.app/v1/images/random"
    }

    override var prodUrl: String? {
        "https://chatbot-ios-backend.vercel.app/v1/images/random"
    }

    static let shared = FeedImageEndpoint()

    // MARK: - Public Methods

    func load() async throws -> AMFeedImageResponse {
        guard let url else { throw E.wrongUrl }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AMFeedImageResponse.self, from: data)

        return response
    }
}
