//
//  DataManager.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import Foundation

final class DataManager {

    // MARK: - Types

    enum E: Error {
        case noChat
        case responseFailed
    }

    // MARK: - Public Properties

    static let shared = DataManager()

    // MARK: - Private Properties

    private let db = CoreDataManager.shared
    private let nm = NotificationsManager.shared
    private let ud = UserDefaultsManager.shared
    private let chatEndpoint = ChatEndpoint.shared

    // MARK: - GET Methods

    func getChats(isSorted: Bool = true) async -> [Chat] {
        guard let entities = try? await db.chats(isSorted: isSorted) else { return [] }

        let chats = await entities.asyncCompactMap {
            await convert(entity: $0)
        }
        return chats
    }

    // MARK: - CREATE Methods

    func createChat() async -> Chat? {
        guard let entity = try? await db.createChat() else { return nil }

        let chat = await convert(entity: entity)
        nm.emit(.chatUpdated(chat))

        return chat
    }

    // MARK: - UPDATE Methods

    func sendMessage(text: String, chat: Chat, version: String?, isNewMessage: Bool) async throws -> String {
        guard let id = chat.id, let entity = db.chat(byId: id) else {
            throw E.noChat
        }
        if isNewMessage {
            _ = try? await db.createMessage(text: text, isUserMessage: true, chat: entity)
            nm.emit(.chatUpdated(await convert(entity: entity)))
        }

        do {
            let response = try await chatEndpoint.ask(request: text, chat: chat, version: version)

            guard let newEntity = db.chat(byId: id) else {
                throw E.noChat
            }
            _ = try? await db.createMessage(text: response, isUserMessage: false, chat: newEntity)
            nm.emit(.chatUpdated(await convert(entity: newEntity)))
            
            return response
        } catch {
            throw E.responseFailed
        }
    }

    func delete(_ chats: [Chat]) async {
        let entities: [ChatEntity] = chats.compactMap { chat in
            guard let id = chat.id else {
                return nil
            }
            return db.chat(byId: id)
        }
        _ = try? await db.deleteChats(chats: entities)
        nm.emit(.chatsRemoved)
    }

    // MARK: - Private Methods

    private func convert(entity: ChatEntity) async -> Chat {
        let messages = ((try? await db.messages(fromChat: entity)) ?? []).compactMap {
            Message(entity: $0)
        }
        let chat = Chat(id: entity.objectID.uriRepresentation(),
                        chatId: entity.chatId,
                        messages: messages)

        return chat
    }
}
