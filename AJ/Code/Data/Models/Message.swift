//
//  Messahe.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import Foundation
//import SwiftData

struct Message: Hashable {

    let id: String
    let text: String
    let date: Date
    let isUserMessage: Bool

    init(id: String, text: String, date: Date, isUserMessage: Bool) {
        self.id = id
        self.text = text
        self.date = date
        self.isUserMessage = isUserMessage
    }
}
