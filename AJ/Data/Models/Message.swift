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
    var language: String?
    var additionalInfo: String?

    init(originalText: String,
         translation: String? = nil,
         date: Date,
         language: String? = nil,
         additionalInfo: String? = nil) {
        self.originalText = originalText
        self.translation = translation
        self.date = date
        self.language = language
        self.additionalInfo = additionalInfo
    }
}
