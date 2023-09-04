//
//  HomeCellModel.swift
//  AskJoe
//
//  Created by Денис on 19.03.2023.
//

import DifferenceKit
import Foundation

enum FeedCellModel: Differentiable, Hashable {

    case trial(messages: Int, images: Int)
    case imageGenerator(AMFeedImageResponse)
    case characters([Person])
    case feed(FeedItem)

    func isContentEqual(to source: FeedCellModel) -> Bool {
        differenceIdentifier == source.differenceIdentifier
    }

    var differenceIdentifier: String {
        switch self {
        case let .imageGenerator(response):
            return response.url + response.title
        case let .trial(messages, images):
            return String(messages + images)
        case let .characters(people):
            return people.map { $0.characterId }.joined()
        case let .feed(item):
            return item.id
        }
    }
}
