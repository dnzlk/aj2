//
//  Storage.swift
//  AJ
//
//  Created by Денис on 16.10.2023.
//

import Foundation

enum AppStorageKeys: String {
    case languages
    case isSpeakAloud

    var key: String {
        rawValue
    }
}
