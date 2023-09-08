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
    case error

    func isContentEqual(to source: ChatCellModel) -> Bool {
        differenceIdentifier == source.differenceIdentifier
    }

    var differenceIdentifier: String {
        switch self {
        case let .message(message):
            return message.id + (message.translation ?? "")
        case .error:
            return "error"
        }
    }
}
