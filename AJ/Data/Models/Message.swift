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

    let id = UUID().uuidString
    let originalText: String
    var translation: String?
    let date: Date
    let isUserMessage: Bool

    init(originalText: String, translation: String? = nil, date: Date, isUserMessage: Bool) {
        self.originalText = originalText
        self.translation = translation
        self.date = date
        self.isUserMessage = isUserMessage
    }
}
