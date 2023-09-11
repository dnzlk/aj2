//
//  Language.swift
//  AJ
//
//  Created by Денис on 08.09.2023.
//

import UIKit

typealias Languages = (Language, Language)
typealias LanguageColors = (bgColor: UIColor?, textColor: UIColor?)


enum Language: String, CaseIterable {
    case english = "en" // BCP-47
    case russian = "ru"

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

    var color: LanguageColors? {
        switch self {
        case .english:
            return (UIColor(Assets.Colors.accentColor), Assets.Colors.textOnAccent)
        case .russian:
            return (Assets.Colors.solidWhite, Assets.Colors.black)
        }
    }
}
