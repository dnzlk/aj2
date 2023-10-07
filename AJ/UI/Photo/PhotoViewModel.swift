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
        case camera
        case library
        case chooseLanguage
        case translating
        case translationDone
    }

    // MARK: - Public Properties

    @Published private(set) var state: State
    @Published var languages: Languages?
    @Published var isShowOriginalPhoto = true
    @Published var source: ImagePicker.Source

    @Published var originalPhoto: UIImage?
    var translatedPhoto: UIImage?

    // MARK: - Private Properties

    private let recognizer = ImageTextRecognizer()
    private var disposables: [AnyCancellable] = []

    // MARK: - Init

    init(source: ImagePicker.Source) {
        self.source = source
        switch source {
        case .camera:
            state = .camera
        case .library:
            state = .library
        }
        $originalPhoto
            .receive(on: DispatchQueue.main)
            .sink { photo in
                guard let photo else { return }
                
                Task { [weak self] in await self?.onReceivedPhoto(photo) }
            }
            .store(in: &disposables)
        $languages
            .receive(on: DispatchQueue.main)
            .sink { languages in
                Task { [weak self] in await self?.onChoseLanguages() }
            }
            .store(in: &disposables)
    }

    // MARK: - Private Methods

    @MainActor
    private func onReceivedPhoto(_ photo: UIImage) {
        state = .chooseLanguage

        languages = .init(from: .english, to: .french)
    }

    @MainActor
    private func onChoseLanguages() async {
        guard state == .chooseLanguage, let languages, let originalPhoto else { return }

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
