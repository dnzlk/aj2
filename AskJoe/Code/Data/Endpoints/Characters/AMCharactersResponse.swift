//
//  AMCharactersResponse.swift
//  AskJoe
//
//  Created by Денис on 18.03.2023.
//

import Foundation

struct AMCharactersResponse: Codable {

    let id: String?
    let type: String?
    let name: String?
    let description: String?
    let avatarUrl: String?
    let prompts: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case description
        case avatarUrl = "avatar_url"
        case prompts
    }

    func person() -> Person? {
        guard let id, let type, let name else { return nil }

        return .init(characterId: id,
                     type: type,
                     name: name,
                     description: description,
                     avatarUrl: avatarUrl,
                     prompts: prompts ?? [])
    }
}
