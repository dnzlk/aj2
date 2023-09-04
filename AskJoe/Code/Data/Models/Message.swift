//
//  Messahe.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import Foundation

struct Message: Hashable {

    let id: URL
    var text: String
    var date: Date
    var isUserMessage: Bool

    init?(entity: MessageEntity) {
        guard let text = entity.text, let date = entity.date else {
            return nil
        }
        self.id = entity.objectID.uriRepresentation()
        self.text = text
        self.date = date
        self.isUserMessage = entity.isUser
    }
}
