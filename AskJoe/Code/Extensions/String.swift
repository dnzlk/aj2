//
//  String.swift
//  AskJoe
//
//  Created by Денис on 28.02.2023.
//

import Foundation

extension String {

    var words: [String] {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
    }
}
