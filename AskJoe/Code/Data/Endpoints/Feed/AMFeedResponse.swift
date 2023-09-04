//
//  AMFeedResponse.swift
//  AskJoe
//
//  Created by Денис on 29.03.2023.
//

import Foundation

struct AMFeedResponse: Codable {

    let id: String?
    let type: String?
    let publishedAt: String?
    let snippet: Snippet?
    let blocks: [Block]?
    let url: String?
    let promptText: String?
    let character: AMCharactersResponse?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case publishedAt = "published_at"
        case snippet
        case blocks
        case url
        case promptText = "prompt_text"
        case character
    }

    struct Snippet: Codable {

        let title: String?
        let imageUrl: String?
        let description: String?
        let buttonText: String?

        enum CodingKeys: String, CodingKey {
            case title
            case imageUrl = "image_url"
            case description
            case buttonText = "button_text"
        }
    }

    struct Block: Codable {

        let index: Int?
        let type: String?
        let content: String?
    }

    func item() -> FeedItem? {
        guard let id, let type else { return nil }

        let date: Date? = {
            guard let publishedAt else { return nil }

            return Date.apiDateFormatter.date(from: publishedAt)
        }()
        guard let snippet else { return nil }

        let itemType: FeedItem.`Type`

        switch type {
        case "post":
            let itemSnippet = FeedItem.PostSnippet(title: snippet.title,
                                                   image: snippet.imageUrl,
                                                   description: snippet.description)
            let itemBlocks: [FeedItem.Block] = blocks?.compactMap { block in
                guard let type = block.type, let content = block.content else { return nil }

                switch type {
                case "text":
                    return .text(content)
                case "image":
                    guard let url = URL(string: content) else { return nil }

                    return .image(url)
                case "subtitle":
                    return .subtitle(content)
                default:
                    return nil
                }
            } ?? []
            itemType = .post(snippet: itemSnippet, blocks: itemBlocks)
        case "post_external":
            guard let url, let url = URL(string: url) else { return nil }

            let itemSnippet = FeedItem.PostSnippet(title: snippet.title,
                                                   image: snippet.imageUrl,
                                                   description: snippet.description)
            itemType = .externalPost(snippet: itemSnippet, url: url)
        case "post_prompt":
            guard let promptText else { return nil }

            let prompt = Prompt(text: promptText)

            itemType = .prompt(prompt: prompt, title: snippet.title)
        case "post_character":
            guard let person = character?.person(), let title = snippet.title else { return nil }

            itemType = .newCharacter(snippet: .init(title: title,
                                                    image: snippet.imageUrl,
                                                    description: snippet.description,
                                                    buttonText: snippet.buttonText),
                                     character: person)
        default:
            return nil
        }
        return .init(id: id,
                     type: itemType,
                     publishedAt: date)
    }
}
