//
//  SecureStoreQueryable.swift
//  AskJoe
//
//  Created by Денис on 26.04.2023.
//

import Foundation

protocol SecureStoreQueryable {
    var query: [String: Any] { get }
}

struct GenericPasswordQueryable {

    enum Key: String {
        case numberOfMessagesLeftToday
        case numberOfImagesLeftToday
    }

    let key: Key
}

extension GenericPasswordQueryable: SecureStoreQueryable {

    var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = key.rawValue
        return query
    }
}
