//
//  SecurityManager.swift
//  AskJoe
//
//  Created by Денис on 02.04.2023.
//

import CryptoKit
import Foundation

final class SecurityManager {

    static let shared = SecurityManager()

    // MARK: - Private Properties

    private let debugModePasswordHash = "c6d2118b1df0dd71234e4582425da2c9d167dba1268bfcb76f89c94da506f657"

    // MARK: - Public Methods

    func checkDebugModePassword(string: String) -> Bool {
        let hashed = SHA256.hash(data: Data(string.utf8))

        return (hashed.description.split(separator: " ").last ?? "") == debugModePasswordHash
    }
}
