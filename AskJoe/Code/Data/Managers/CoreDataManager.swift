//
//  CoreDataManager.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import CoreData
import Foundation

final class CoreDataManager {

    // MARK: - Public Properties

    static let shared = CoreDataManager()

    // MARK: - Private Properties

    private lazy var context: NSManagedObjectContext = storeContainer.viewContext

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatDataModel")
        container.loadPersistentStores { _, _ in }
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        return container
    }()

    // MARK: - GET Methods

    func chats(isSorted: Bool) async throws -> [ChatEntity] {
        let request = ChatEntity.fetchRequest()

        if isSorted {
            let sort = NSSortDescriptor(key: #keyPath(ChatEntity.createdAt), ascending: false)
            request.sortDescriptors = [sort]
        }
        return try await context.get(request: request)
    }

    func chat(byId id: URL) -> ChatEntity? {
        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else {
            return nil
        }
        return try? context.existingObject(with: objectId) as? ChatEntity
    }

    func messages(fromChat chat: ChatEntity) async throws -> [MessageEntity] {
        let request = MessageEntity.fetchRequest()
        let chatPredicate = NSPredicate(format: "chat = %@", chat)
        request.predicate = chatPredicate

        return try await context.get(request: request)
    }

    func message(byId id: URL) -> MessageEntity? {
        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else {
            return nil
        }
        return try? context.existingObject(with: objectId) as? MessageEntity
    }

    func persons() async throws -> [PersonEntity] {
        let request = PersonEntity.fetchRequest()

        return try await context.get(request: request)
    }

    // MARK: CREATE Methods

    func createChat(person: Person?) async throws -> ChatEntity? {
        var personEntity: PersonEntity?

        if let person {
            let persons = try? await persons()

            personEntity = persons?.first(where: { $0.character_id == person.characterId })
        }
        try context.performAndWait {
            let chat = ChatEntity(context: context)
            chat.createdAt = Date()
            chat.chatId = UUID().uuidString

            if let person {
                if let personEntity {
                    chat.person = personEntity
                } else {
                    let personEntity = PersonEntity(context: context)
                    personEntity.character_id = person.characterId
                    personEntity.name = person.name
                    personEntity.desc = person.description
                    personEntity.avatarUrl = person.avatarUrl
                    personEntity.type = person.type
                    personEntity.prompts = person.prompts.joined(separator: ";")
                    
                    chat.person = personEntity
                }
            }
            try context.save()
        }
        let chats = try await chats(isSorted: true)

        return chats.first
    }

    func createMessage(text: String, isUserMessage: Bool, chat: ChatEntity) async throws -> MessageEntity? {
        try context.performAndWait {
            let message = MessageEntity(context: context)
            message.text = text
            message.date = Date()
            message.isUser = isUserMessage
            chat.addToMessages(message)

            try context.save()
        }
        let message = try await messages(fromChat: chat).first

        return message
    }

    // MARK: - UPDATE Methods

    func updateChat(chat: ChatEntity, summaryText: String?) throws {
        try context.performAndWait {
            if let summaryText {
                chat.summaryText = summaryText
            }
            try context.save()
        }
    }

    // MARK: - DELETE Methods

    @discardableResult
    func deleteChats(chats: [ChatEntity]) async throws -> Bool {
        try context.performAndWait {
            chats.forEach { context.delete($0) }
            try context.save()
        }
        let _chats = try await self.chats(isSorted: true)

        return _chats.isEmpty
    }
}

// MARK: - Extension NSManagedObjectContext

private extension NSManagedObjectContext {

    func get<E>(request: NSFetchRequest<E>) async throws -> [E] where E: NSManagedObject {
        try await self.perform { [weak self] in
            try self?.fetch(request) ?? []
        }
    }
}
