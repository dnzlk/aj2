//
//  Post.swift
//  AskJoe
//
//  Created by Денис on 30.03.2023.
//

import Foundation

struct Post {

    let title: String
    let blocks: [FeedItem.Block]
    let createdAt: Date?

    static let testData: Post = .init(title: "10 Essential Tips for Crafting a Killer Cold Email With+90% Open Rate 😍 💯",
                                       blocks: [.text("Cold emailing can be an effective way to generate leads and grow your business. Crafting a cold email that grabs the attention of your recipient and gets the desired results can be a challenging task 😥"),
                                                .image(URL(string: "https://askjoecharactersavatars.s3.amazonaws.com/293051c8-beaa-499a-9d9a-468dd79cb577.png")!),
                                                .text("However, with the right approach and strategy, you can create a killer cold email that not only gets opened but also elicits a response.")],
                                       createdAt: Date())
}
