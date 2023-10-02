//
//  DateFormatters.swift
//  AJ
//
//  Created by Денис on 02.10.2023.
//

import Foundation

extension Date {

    static private let dayFormatter = DateFormatter()

    var day: String {
        Self.dayFormatter.dateFormat = "MMM d"

        if Calendar.current.isDateInToday(self) {
            return "Today"
        }
        if Calendar.current.isDateInYesterday((self)) {
            return "Yesterday"
        }
        return Self.dayFormatter.string(from: (self))
    }
}
