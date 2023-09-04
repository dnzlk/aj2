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

        case startingDay

        case lastTimePromptsWereGenerated
        case lastGeneratedDailyPrompts        

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

    func getStartingDay() -> Double {
        UserDefaults.standard.double(forKey: Keys.startingDay.id)
    }

    func getLastTimePromptsWereGenerated() -> Double {
        UserDefaults.standard.double(forKey: Keys.lastTimePromptsWereGenerated.id)
    }

    func getLastGeneratedDailyPrompts() -> [Prompt]? {
        if let data = UserDefaults.standard.object(forKey: Keys.lastGeneratedDailyPrompts.id) as? Data,
           let prompts = try? JSONDecoder().decode([Prompt].self, from: data) {
            return prompts
        }
        return nil
    }

    // MARK: - SAVE Methods

    func setDebugMode(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: Keys.debugMode.id)
    }

    func saveStartingDay(date: Date) {
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: Keys.startingDay.id)
    }

    func saveLastTimePromptsWereGenerated(date: Date) {
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: Keys.lastTimePromptsWereGenerated.id)
    }

    func saveLastGeneratedDailyPrompts(prompts: [Prompt]) {
        if let encoded = try? JSONEncoder().encode(prompts) {
            UserDefaults.standard.set(encoded, forKey: Keys.lastGeneratedDailyPrompts.id)
        }
    }
}
