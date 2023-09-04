//
//  ChatEntity+CoreDataProperties.swift
//  AskJoe
//
//  Created by Денис on 28.04.2023.
//
//

import Foundation
import CoreData


extension ChatEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatEntity> {
        return NSFetchRequest<ChatEntity>(entityName: "ChatEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var summaryText: String?
    @NSManaged public var chatId: String?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension ChatEntity {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageEntity)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageEntity)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension ChatEntity : Identifiable {

}
