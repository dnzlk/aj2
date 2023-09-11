//
//  ChatTableDataSource.swift
//  AskJoe
//
//  Created by Денис on 22.02.2023.
//

import DifferenceKit
import UIKit

enum ChatCellModel: Differentiable, Hashable {
    case message(message: Message, style: MessageCell.Style)

    func isContentEqual(to source: ChatCellModel) -> Bool {
        differenceIdentifier == source.differenceIdentifier
    }

    var differenceIdentifier: String {
        switch self {
        case let .message(message, _):
            return message.id + (message.translation ?? "") + (message.additionalInfo ?? "")
        }
    }
}
