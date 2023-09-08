//
//  Chat.swift
//  AJ
//
//  Created by Денис on 08.09.2023.
//

import Foundation
import SwiftData

@Model
class Chat: Hashable {

    var messages: [Message]
    var languages: [String]

    init(messages: [Message], languages: [String]) {
        self.messages = messages
        self.languages = languages
    }
}
