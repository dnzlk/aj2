//
//  Post.swift
//  AskJoe
//
//  Created by Денис on 23.03.2023.
//

import Foundation

struct FeedItem: Hashable {

    let id: String
    let type: Type
    let publishedAt: Date?

    // MARK: - Snippets

    struct PostSnippet: Hashable {

        let title: String?
        let image: String?
        let description: String?
    }

    struct CharacterSnippet: Hashable {

        let title: String
        let image: String?
        let description: String?
        let buttonText: String?
    }

    enum Block: Hashable {
        case text(String)
        case image(URL)
        case subtitle(String)
    }

    enum `Type`: Hashable {
        case post(snippet: PostSnippet, blocks: [Block])
        case externalPost(snippet: PostSnippet, url: URL)
        case newCharacter(snippet: CharacterSnippet, character: Person)
        case prompt(prompt: Prompt, title: String? = nil)
    }
}
