//
//  MessageEntity+CoreDataProperties.swift
//  AskJoe
//
//  Created by Денис on 22.03.2023.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isUser: Bool
    @NSManaged public var text: String?
    @NSManaged public var chat: ChatEntity?

}

extension MessageEntity : Identifiable {

}
