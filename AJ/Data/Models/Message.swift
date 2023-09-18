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
    var translation: String?
    let createdAt: Date
    var language: String?
    var state: State
    var isSentByUser: Bool?
    var isFav: Bool

    init(id: String = UUID().uuidString,
         originalText: String,
         translation: String? = nil,
         createdAt: Date,
         language: String? = nil,
         state: State = .loading,
         isSentByUser: Bool? = nil,
         isFav: Bool = false) {
        self.id = id
        self.originalText = originalText
        self.translation = translation
        self.createdAt = createdAt
        self.language = language
        self.state = state
        self.isSentByUser = isSentByUser
        self.isFav = isFav
    }

    enum State: String {
        case loading
        case failed
        case loaded
    }
}
