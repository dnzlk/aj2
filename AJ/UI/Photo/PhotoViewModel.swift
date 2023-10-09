//
//  PhotoViewModel.swift
//  AJ
//
//  Created by Денис on 07.10.2023.
//

import Combine
import SwiftUI

final class PhotoViewModel: ObservableObject {

    // MARK: - Types

    enum State {
        case initial
        case translating
        case translationDone
    }

    // MARK: - Public Properties

    @Published private(set) var state: State = .initial
    @Published var languages = UserDefaultsManager.shared.languages()
    @Published var isShowOriginalPhoto = true

    @Published var source: ImagePicker.Source?

    @Published var originalPhoto: UIImage?
    var translatedPhoto: UIImage?


    // MARK: - Private Properties

    private let recognizer = ImageTextRecognizer()
    private var disposables: [AnyCancellable] = []

    // MARK: - Init

    init() {
        $originalPhoto
            .receive(on: DispatchQueue.main)
            .sink { _ in
                Task { [weak self] in await self?.translate() }
            }
            .store(in: &disposables)
    }

    // MARK: - Private Methods

    @MainActor
    private func translate() async {
        guard let originalPhoto else { return }

        state = .translating

        do {
            translatedPhoto = try await recognizer.recognizeText(onImage: originalPhoto, languages: languages)
            isShowOriginalPhoto = false
            state = .translationDone
        } catch  {
            print(error)
        }
    }
}
