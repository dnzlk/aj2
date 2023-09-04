//
//  Person.swift
//  AskJoe
//
//  Created by Денис on 18.03.2023.
//

import Foundation

struct Person: Hashable {

    let characterId: String
    let type: String
    let name: String
    let description: String?
    let avatarUrl: String?
    let prompts: [String]

    init(characterId: String,
         type: String,
         name: String,
         description: String? = nil,
         avatarUrl: String? = nil,
         prompts: [String]) {
        self.characterId = characterId
        self.type = type
        self.name = name
        self.description = description
        self.avatarUrl = avatarUrl
        self.prompts = prompts
    }


    init?(entity: PersonEntity?) {
        guard let entity,
              let id = entity.character_id,
              let name = entity.name,
              let type = entity.type
        else {
            return nil
        }
        self.characterId = id
        self.name = name
        self.type = type
        self.description = entity.desc
        self.avatarUrl = entity.avatarUrl
        self.prompts = Array(entity.prompts?.components(separatedBy: ";") ?? [])
    }
}
