//
//  Service.swift
//  AskJoe
//
//  Created by Денис on 02.04.2023.
//

import Foundation

class APIEndpoint {


    // MARK: - Public Properties

    var debugUrl: String? { nil }
    var prodUrl: String? { nil }

    var url: URL? {
        let stringURL: String
        let isDebugMode = false//UserDefaultsManager.shared.isDebugMode()

        if isDebugMode, let debugUrl {
            stringURL = debugUrl
        } else if let prodUrl {
            stringURL = prodUrl
        } else {
            return nil
        }
        return URL(string: stringURL)
    }
}
