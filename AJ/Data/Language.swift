//
//  Language.swift
//  AJ
//
//  Created by Денис on 08.09.2023.
//

import SwiftUI

struct Languages: Equatable {
    
    var from: Language
    var to: Language
}
typealias LanguageColors = (bgColor: Color, textColor: Color)


enum Language: String, CaseIterable, Equatable {
    case english = "en" // BCP-47
    case chineseSimplified = "zh-Hans"
    case spanish = "es"
    case arabic = "ar"
    case hindi = "hi"
    case french = "fr"
    case bengali = "bn"
    case russian = "ru"
    case portuguese = "pt"
    case indonesian = "id"
    case turkish = "tr"
    case armenian = "hy"
    case georgian = "ka"
    case kazakh = "kk"

    struct LanguageColors {
        var bgColor: Color
        var textColor: Color
    }

    var localizedName: String {
        switch self {
        case .english:
            return "English"
        case .chineseSimplified:
            return "中文 (简体)"
        case .spanish:
            return "Español"
        case .arabic:
            return "العربية"
        case .hindi:
            return "हिन्दी"
        case .french:
            return "Français"
        case .bengali:
            return "বাঙালি"
        case .russian:
            return "Русский"
        case .portuguese:
            return "Português"
        case .indonesian:
            return "Bahasa Indonesia"
        case .turkish:
            return "Türkçe"
        case .armenian:
            return "Հայերեն"
        case .georgian:
            return "ქართული"
        case .kazakh:
            return "Қазақша"
        }
    }

    var flag: String {
        switch self {
        case .english:
            return "🇬🇧"
        case .chineseSimplified:
            return "🇨🇳"
        case .spanish:
            return "🇪🇸"
        case .arabic:
            return "🇦🇪"
        case .hindi:
            return "🇮🇳"
        case .french:
            return "🇫🇷"
        case .bengali:
            return "🇧🇩"
        case .russian:
            return "🇷🇺"
        case .portuguese:
            return "🇵🇹"
        case .indonesian:
            return "🇮🇩"
        case .turkish:
            return "🇹🇷"
        case .armenian:
            return "🇦🇲"
        case .georgian:
            return "🇬🇪"
        case .kazakh:
            return "🇰🇿"
        }
    }

    var typeHereText: String {
        switch self {
        case .english:
            return "Type here"
        case .chineseSimplified:
            return "在这里输入"
        case .spanish:
            return "Escribe aquí"
        case .arabic:
            return "اكتب هنا"
        case .hindi:
            return "यहां लिखें"
        case .french:
            return "Écrivez ici"
        case .bengali:
            return "এখানে লিখুন"
        case .russian:
            return "Пишите здесь"
        case .portuguese:
            return "Digite aqui"
        case .indonesian:
            return "Ketik di sini"
        case .turkish:
            return "Buraya yazın"
        case .armenian:
            return "Գրեք այստեղ"
        case .georgian:
            return "დაწერეთ აქ"
        case .kazakh:
            return "Осында жазыңыз"
        }
    }

    var speakText: String {
        switch self {
        case .english:
            return "Speak"
        case .chineseSimplified:
            return "说话"
        case .spanish:
            return "Hablar"
        case .arabic:
            return "تحدث"
        case .hindi:
            return "बोलो"
        case .french:
            return "Parler"
        case .bengali:
            return "কথা বলুন"
        case .russian:
            return "Говорите"
        case .portuguese:
            return "Falar"
        case .indonesian:
            return "Bicara"
        case .turkish:
            return "Konuş"
        case .armenian:
            return "Խոսեք"
        case .georgian:
            return "ლაპარაკო"
        case .kazakh:
            return "Сөйле"
        }
    }

    var color: LanguageColors {
        switch self {
        case .english:
            return LanguageColors(bgColor: .blue, textColor: .white)
        case .chineseSimplified:
            return LanguageColors(bgColor: .red, textColor: .white)
        case .spanish:
            return LanguageColors(bgColor: .yellow, textColor: .black)
        case .arabic:
            return LanguageColors(bgColor: .green, textColor: .white)
        case .hindi:
            return LanguageColors(bgColor: .orange, textColor: .black)
        case .french:
            return LanguageColors(bgColor: .blue, textColor: .white)
        case .bengali:
            return LanguageColors(bgColor: .green, textColor: .white)
        case .russian:
            return LanguageColors(bgColor: .white, textColor: .blue)
        case .portuguese:
            return LanguageColors(bgColor: .green, textColor: .white)
        case .indonesian:
            return LanguageColors(bgColor: .red, textColor: .white)
        case .turkish:
            return LanguageColors(bgColor: .red, textColor: .white)
        case .armenian:
            return LanguageColors(bgColor: .orange, textColor: .black)
        case .georgian:
            return LanguageColors(bgColor: .blue, textColor: .white)
        case .kazakh:
            return LanguageColors(bgColor: .blue, textColor: .white)
        }
    }
}
