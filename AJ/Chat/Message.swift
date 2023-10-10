//
//  Messahe.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import Foundation
import SwiftData

@Model
class Message: Hashable {

    let id: String
    let originalText: String
    var translation: Translation?
    let createdAt: Date
    var isFav: Bool
    var isShowOriginalText = false

    init(id: String = UUID().uuidString,
         originalText: String,
         translation: Translation? = nil,
         createdAt: Date,
         isFav: Bool = false) {
        self.id = id
        self.originalText = originalText
        self.translation = translation
        self.createdAt = createdAt
        self.isFav = isFav
    }

    struct Translation: Codable {

        var text: String
        var language: String
        var isSentByUser: Bool
    }

    enum State: Codable {
        case loading
        case loaded
    }
}
