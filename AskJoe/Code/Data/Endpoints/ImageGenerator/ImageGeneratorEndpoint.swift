//
//  ImageGeneratorService.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import Foundation

final class ImageGeneratorEndpoint: APIEndpoint {

    // MARK: - Public Properties

    static let shared = ImageGeneratorEndpoint()

    override var debugUrl: String? {
        "https://chatbot-ios-backend-test.vercel.app/chat/image"
    }

    override var prodUrl: String? {
        "https://chatbot-ios-backend.vercel.app/chat/image"
    }

    // MARK: - Public Methods

    func load(request: String) async throws -> String {
        guard let url else { throw E.wrongUrl }

        let amRequest = AMImageRequest(prompt: request)
        let encodedAmRequest = try JSONEncoder().encode(amRequest)

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedAmRequest

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AMImageResponse.self, from: data)

        return response.url
    }
}
