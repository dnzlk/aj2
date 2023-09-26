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
    var error: String?
    @Transient var isPlaying = false
    var isShowOriginalText = false

    var state: State {
        if error != nil {
            return .failed
        }
        if translation == nil {
            return .loading
        }
        return .loaded
    }

    init(id: String = UUID().uuidString,
         originalText: String,
         translation: Translation? = nil,
         createdAt: Date,
         isFav: Bool = false,
         error: String? = nil) {
        self.id = id
        self.originalText = originalText
        self.translation = translation
        self.createdAt = createdAt
        self.isFav = isFav
        self.error = error
    }

    struct Translation: Codable {

        var text: String
        var language: String
        var isSentByUser: Bool
    }

    enum State: Codable {
        case loading
        case failed
        case loaded
    }
}
