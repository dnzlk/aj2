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
        case debugMode

        var id: String {
            rawValue
        }
    }

    // MARK: - Public Properties

    static let shared = UserDefaultsManager()

    // MARK: - GET Methods

    func isDebugMode() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.debugMode.id)
    }

    // MARK: - SAVE Methods

    func setDebugMode(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: Keys.debugMode.id)
    }
}
