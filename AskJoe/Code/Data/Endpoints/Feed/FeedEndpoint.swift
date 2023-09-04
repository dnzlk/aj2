//
//  FeedService.swift
//  AskJoe
//
//  Created by Денис on 23.03.2023.
//

import Foundation

final class FeedEndpoint: APIEndpoint {

    // MARK: - Public Properties

    static let shared = FeedEndpoint()

    override var debugUrl: String? {
        "https://chatbot-ios-backend-test.vercel.app/v1/feed"
    }

    override var prodUrl: String? {
        "https://chatbot-ios-backend.vercel.app/v1/feed"
    }

    // MARK: - Public Methods

    func load(offset: Int, limit: Int) async throws -> [FeedItem] {
        guard let rootUrl = url?.absoluteString else { throw E.wrongUrl }
        let stringURL = rootUrl + "?limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: stringURL) else { throw E.wrongUrl }

        let (data, _) = try await URLSession.shared.data(from: url)
        let amFeed = try JSONDecoder().decode([AMFeedResponse].self, from: data)

        return amFeed.compactMap { $0.item() }
    }
}
