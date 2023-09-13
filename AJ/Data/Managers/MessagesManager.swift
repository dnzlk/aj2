//
//  MessagesManager.swift
//  AJ
//
//  Created by Денис on 07.09.2023.
//

import Foundation
import SwiftData

@MainActor
final class MessagesManager {

    static let shared = MessagesManager()

    // MARK: - Private Properties

    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

    // MARK: - Init

    init() {
        guard let container = try? ModelContainer(for: Message.self) else { return }

        modelContainer = container
        modelContext = ModelContext(container)
    }

    // MARK: - Public Methods

    func get() -> [Message] {
        let fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(\Message.date)])

        return (try? modelContext?.fetch(fetchDescriptor)) ?? []
    }

    func save(_ message: Message) {
        modelContext?.insert(message)
    }

    func update(isFav: Bool, message: Message) {
        let newMessage = Message(originalText: message.originalText,
                                 translation: message.translation,
                                 date: message.date,
                                 language: message.language,
                                 additionalInfo: message.additionalInfo,
                                 isFav: message.isFav)
        modelContext?.delete(message)
        save(newMessage)
    }
}
