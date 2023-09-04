//
//  PersonEntity+CoreDataProperties.swift
//  AskJoe
//
//  Created by Денис on 22.03.2023.
//
//

import Foundation
import CoreData


extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var character_id: String?
    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var prompts: String?
    @NSManaged public var type: String?
    @NSManaged public var chats: NSSet?

}

// MARK: Generated accessors for chats
extension PersonEntity {

    @objc(addChatsObject:)
    @NSManaged public func addToChats(_ value: ChatEntity)

    @objc(removeChatsObject:)
    @NSManaged public func removeFromChats(_ value: ChatEntity)

    @objc(addChats:)
    @NSManaged public func addToChats(_ values: NSSet)

    @objc(removeChats:)
    @NSManaged public func removeFromChats(_ values: NSSet)

}

extension PersonEntity : Identifiable {

}
