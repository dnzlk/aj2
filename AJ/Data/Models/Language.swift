//
//  Language.swift
//  AJ
//
//  Created by Денис on 08.09.2023.
//

import Foundation
import SwiftData

typealias Languages = (Language, Language)

enum Language: String {
    case english
    case russian

    var flag: String {
        switch self {
        case .english:
            return "🇬🇧"
        case .russian:
            return "🇷🇺"
        }
    }

    var typeHereText: String {
        switch self {
        case .english:
            return "Type here"
        case .russian:
            return "Пишите здесь"
        }
    }
}
