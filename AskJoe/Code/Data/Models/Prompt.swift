//
//  Prompt.swift
//  AskJoe
//
//  Created by Денис on 14.02.2023.
//

import Foundation

struct Prompt: Codable, Hashable {

    var text: String
    var date: Date?
}

extension Prompt {

    private static let hardcodedPrompts: [Prompt] = [.init(text: "Explain quantum physics"),
                                             .init(text: "Explain the concept of time like I am a dog"),
                                             .init(text: "Explain the concept of time like I am three years old"),
                                             .init(text: "Use florid, baroque language to describe a potato"),
                                             .init(text: "Write a short poem about rabbit"),
                                             .init(text: "Write a breaking news article about a potato"),
                                             .init(text: "Write a birthday congrats to my grandma's 90 birthday in ultra gen z style"),
                                             .init(text: "Write a invitation to party in wu tang style"),
                                             .init(text: "Tell me about solar system"),
                                             .init(text: "How to say 'I will make him an offer you can't refuse' in Spanish"),
                                             .init(text: "How to say 'I will make him an offer you can't refuse' in Klingon"),
                                             .init(text: "How to say 'I will make him an offer you can't refuse' in made-up language"),
                                             .init(text: "Ask for a raise in ultra gen z style"),
                                             .init(text: "Sell me this pen")]

    static func random(_ count: Int) -> [Prompt] {
        guard count <= hardcodedPrompts.count else { return [] }
        
        var prompts: [Prompt] = []
        var selectedIndexes: [Int] = []

        for _ in 0..<count {
            var index: Int

            repeat {
                index = Int.random(in: 0..<hardcodedPrompts.count)
            } while selectedIndexes.contains(index)
            selectedIndexes.append(index)

            prompts.append(hardcodedPrompts[index])
        }
        return prompts
    }
}
