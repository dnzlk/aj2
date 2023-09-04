//
//  Chat.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import Foundation

struct Chat: Hashable {

    let id: URL?
    let chatId: String?
    var messages: [Message]
}
