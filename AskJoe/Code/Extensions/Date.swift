//
//  Date.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import Foundation

extension Date {

    static private let dayFormatter = DateFormatter()
    static private let timeFormatter = DateFormatter()

    var formatPromptDate: String {
        Self.dayFormatter.dateFormat = "dd MMMM"
        Self.timeFormatter.dateFormat = "h:mm a"

        let day: String = {
            if Calendar.current.isDateInToday(self) {
                return L10n.History.today
            }
            if Calendar.current.isDateInYesterday((self)) {
                return L10n.History.yesterday
            }
            return Self.dayFormatter.string(from: (self))
        }()

        let time = Self.timeFormatter.string(from: (self))

        return L10n.History.at(day, time.lowercased())
    }

    var formatPostDate: String {
        Self.dayFormatter.dateFormat = "MMM d, yyyy"

        let day: String = {
            if Calendar.current.isDateInToday(self) {
                return L10n.History.today
            }
            if Calendar.current.isDateInYesterday((self)) {
                return L10n.History.yesterday
            }
            return Self.dayFormatter.string(from: (self))
        }()
        return day
    }

    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
