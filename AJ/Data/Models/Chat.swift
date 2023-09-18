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
    @Transient var pendingMessage: (message: Message, hasFailed: Bool)?

    var allMessages: [Message] {
        messages + (pendingMessage != nil ? [pendingMessage!.message] : [])
    }

    init(messages: [Message]) {
        self.messages = messages
    }
}
