//
//  ScheduleMessageService.swift
//  AskJoe
//
//  Created by Денис on 09.05.2023.
//

import Foundation

final class ScheduleMessageEndpoint: APIEndpoint {

    // MARK: - Public Properties

    static let shared = ScheduleMessageEndpoint()
    
    override var debugUrl: String? {
        "https://chatbot-ios-backend-test.vercel.app/v1/push-notifications/test"
    }

    override var prodUrl: String? {
        "https://chatbot-ios-backend-test.vercel.app/v1/push-notifications/test"
    }

    // MARK: - Public Methods

    func schedule(token: String) async throws {
        guard let url else { throw E.wrongUrl }

        let timezone = "UTC+05:00"//TimeZone.current.abbreviation() ?? ""
        let amRequest = AMScheduleMessageRequest(token: token, timezone: timezone)
        let encodedAmRequest = try JSONEncoder().encode(amRequest)

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedAmRequest

        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
