//
//  Languages.swift
//  AJ
//
//  Created by Денис on 16.10.2023.
//

import Foundation

struct Languages: Equatable, Codable {

    var from: Language
    var to: Language

    static let defaultValues: Languages = .init(from: .english, to: .russian)
}

extension Languages: RawRepresentable {

    init?(rawValue: String) {
        let components = rawValue.split(separator: "_")

        guard
            components.count == 2,
            let from = Language(rawValue: String(components[0])),
            let to = Language(rawValue: String(components[1]))
        else {
            return nil
        }
        self.from = from
        self.to = to
    }

    var rawValue: String {
        return "\(from.rawValue)_\(to.rawValue)"
    }
}
