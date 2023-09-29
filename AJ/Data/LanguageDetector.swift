//
//  LanguageDetector.swift
//  AJ
//
//  Created by Денис on 29.09.2023.
//

import Foundation
import NaturalLanguage

final class LanguageDetector {

    static let shared = LanguageDetector()

    private init() {}

    func detectedLanguage(for string: String, languages: Languages) -> Language? {
        let recognizer = NLLanguageRecognizer()
        recognizer.languageConstraints = [languages.from.rawValue, languages.to.rawValue].map { NLLanguage(rawValue: $0) }
        recognizer.processString(string)

        guard let result = recognizer.dominantLanguage?.rawValue else { return nil }

        return Language(rawValue: result)
    }
}
