//
//  TranslateUseCase.swift
//  AJ
//
//  Created by Денис on 19.09.2023.
//

import Foundation

final class TranslateUseCase {

    enum E: Error {
        case previousLoadingInProgress
        case emptyText
        case loadingFailed(String)
    }

    var languages: Languages = (.english, .russian)

    private let te = TranslateEndpoint.shared
    private var isLoading = false

    init(languages: Languages) {
        self.languages = languages
    }

    func translate(text: String) async throws -> Translation {
        guard !isLoading else { throw E.previousLoadingInProgress }

        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { throw E.emptyText }

        do {
            isLoading = true

            return try await te.translate(text: text, languages: languages)
        } catch {
            throw E.loadingFailed(error.localizedDescription)
        }
    }
}
