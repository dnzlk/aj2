//
//  ChatTableDataSource.swift
//  AskJoe
//
//  Created by Денис on 22.02.2023.
//

import DifferenceKit
import UIKit

enum ChatCellModel: Differentiable, Hashable {
    case date(Date)
    case message(Message)
    case joeIsTyping
    case tryAgainError

    func isContentEqual(to source: ChatCellModel) -> Bool {
        differenceIdentifier == source.differenceIdentifier
    }

    var differenceIdentifier: String {
        switch self {
        case let .date(date):
            return String(date.timeIntervalSince1970)
        case .joeIsTyping:
            return "joeIsTyping"
        case let .message(message):
            return message.id
        case .tryAgainError:
            return "tryAgainError"
        }
    }
}
