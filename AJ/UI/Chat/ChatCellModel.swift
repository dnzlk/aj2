//
//  ChatTableDataSource.swift
//  AskJoe
//
//  Created by Денис on 22.02.2023.
//

import DifferenceKit
import UIKit

enum ChatCellModel: Differentiable, Hashable {
    case message(Message)
    case joeIsTyping
    case tryAgainError

    func isContentEqual(to source: ChatCellModel) -> Bool {
        differenceIdentifier == source.differenceIdentifier
    }

    var differenceIdentifier: String {
        switch self {
        case .joeIsTyping:
            return "joeIsTyping"
        case let .message(message):
            return message.id
        case .tryAgainError:
            return "tryAgainError"
        }
    }
}
