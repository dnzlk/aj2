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

    struct LanguageColors {
        var bgColor: Color
        var textColor: Color
    }
    
    case english = "en" // BCP-47
    case chineseSimplified = "zh-Hans"
    case spanish = "es"
    case arabic = "ar"
    case hindi = "hi"
    case italian = "it"
    case french = "fr"
    case bengali = "bn"
    case russian = "ru"
    case portuguese = "pt"
    case indonesian = "id"
    case turkish = "tr"
    case armenian = "hy"
    case georgian = "ka"
    case kazakh = "kk"

    var code: String {
        rawValue
    }

    var englishName: String {
            switch self {
            case .english:
                return "English"
            case .chineseSimplified:
                return "Chinese (Simplified)"
            case .spanish:
                return "Spanish"
            case .arabic:
                return "Arabic"
            case .hindi:
                return "Hindi"
            case .italian:
                return "Italian"
            case .french:
                return "French"
            case .bengali:
                return "Bengali"
            case .russian:
                return "Russian"
            case .portuguese:
                return "Portuguese"
            case .indonesian:
                return "Indonesian"
            case .turkish:
                return "Turkish"
            case .armenian:
                return "Armenian"
            case .georgian:
                return "Georgian"
            case .kazakh:
                return "Kazakh"
            }
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
        case .italian:
            return "Italiano"
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
        case .italian:
            return "🇮🇹"
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
        case .italian:
            return "Scrivi qui"
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
        case .italian:
             return "Parla"
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
        case .italian:
            return LanguageColors(bgColor: .green, textColor: .white)
        case .french:
            return LanguageColors(bgColor: .blue, textColor: .white)
        case .bengali:
            return LanguageColors(bgColor: .green, textColor: .white)
        case .russian:
            return LanguageColors(bgColor: .init(red: 50/255, green: 135/255, blue: 199/255), textColor: .white)
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

    var locale: String {
        switch self {
        case .english:
            return "en_US"
        case .chineseSimplified:
            return "zh_Hans_CN"
        case .spanish:
            return "es_ES"
        case .arabic:
            return "ar_SA"
        case .hindi:
            return "hi_IN"
        case .italian:
            return "it_IT"
        case .french:
            return "fr_FR"
        case .bengali:
            return "bn_BD"
        case .russian:
            return "ru_RU"
        case .portuguese:
            return "pt_PT"
        case .indonesian:
            return "id_ID"
        case .turkish:
            return "tr_TR"
        case .armenian:
            return "hy_AM"
        case .georgian:
            return "ka_GE"
        case .kazakh:
            return "kk_KZ"
        }
    }

    var selectLanguage: String {
        switch self {
        case .english:
            return "Select language"
        case .chineseSimplified:
            return "选择语言"
        case .spanish:
            return "Seleccionar idioma"
        case .arabic:
            return "اختر اللغة"
        case .hindi:
            return "भाषा चुनें"
        case .italian:
            return "Seleziona lingua"
        case .french:
            return "Sélectionnez la langue"
        case .bengali:
            return "ভাষা নির্বাচন করুন"
        case .russian:
            return "Выберите язык"
        case .portuguese:
            return "Selecionar idioma"
        case .indonesian:
            return "Pilih bahasa"
        case .turkish:
            return "Dil seçin"
        case .armenian:
            return "Ընտրեք լեզվը"
        case .georgian:
            return "აირჩიეთ ენა"
        case .kazakh:
            return "Тілді таңдау"
        }
    }

    var appIcon: String {
        let name: String

        switch self {
        case .english:
            name = "ICEn"
        case .chineseSimplified:
            name = "ICCh"
        case .spanish:
            name = "ICSp"
        case .arabic:
            name = "ICAr"
        case .hindi:
            name = "ICHi"
        case .italian:
            name = "ICIt"
        case .french:
            name = "ICFr"
        case .bengali:
            name = "ICBe"
        case .russian:
            name = "ICRu"
        case .portuguese:
            name = "ICPo"
        case .indonesian:
            name = "ICIn"
        case .turkish:
            name = "ICTu"
        case .armenian:
            name = "ICArm"
        case .georgian:
            name = "ICGe"
        case .kazakh:
            name = "ICKz"
        }
        return name
    }
}
