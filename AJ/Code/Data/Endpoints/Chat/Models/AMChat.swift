//
//  AMChatRequest.swift
//  AskJoe
//
//  Created by Денис on 03.03.2023.
//

import Foundation

struct AMChat: Codable {

    let characterId: String?
    let messages: [AMChatMessage]
    let version: String?
    let chatId: String?

    enum CodingKeys: String, CodingKey {
        case characterId = "character_id"
        case messages
        case version = "model_version"
        case chatId = "chat_id"
    }
}
