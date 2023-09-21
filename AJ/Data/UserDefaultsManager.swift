//
//  UserDefaultsManager.swift
//  AskJoe
//
//  Created by Денис on 22.02.2023.
//

import Foundation

final class UserDefaultsManager {

    // MARK: - Types

    enum Keys: String {
        case languages

        var id: String {
            rawValue
        }
    }

    // MARK: - Public Properties

    static let shared = UserDefaultsManager()

    // MARK: - GET Methods

    func languages() -> Languages {
        let defaultValue: Languages = .init(from: .spanish, to: .english)
        
        if let string = UserDefaults.standard.string(forKey: Keys.languages.id) {
            let parts = string.components(separatedBy: ",")

            guard parts.count == 2,
                  let language1 = Language(rawValue: parts[0]),
                  let language2 = Language(rawValue: parts[1])
            else {
                return defaultValue
            }
            return .init(from: language1, to: language2)
        }
        return defaultValue
    }

    // MARK: - SAVE Methods

    func saveLanguages(languages: Languages) {
        let value = "\(languages.from.rawValue),\(languages.to.rawValue)"
        UserDefaults.standard.set(value, forKey: Keys.languages.id)
    }
}
