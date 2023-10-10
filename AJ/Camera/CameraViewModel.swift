//
//  CameraViewModel.swift
//  Camera
//
//  Created by Денис on 09.10.2023.
//

import AVFoundation
import SwiftUI

final class CameraViewModel: ObservableObject {

    // MARK: - Public Properties

    @Published var preview: Image?
    @Published var libraryThumbnail: Image?
    @Published var originalImage: UIImage? {
        didSet {
            Task { [weak self] in await self?.translate() }
        }
    }
    @Published var translatedImage: UIImage?
    @Published var isShowOriginalPhoto = true
    @Published var languages = UserDefaultsManager.shared.languages()
    @Published var isTranslating = false

    @Published var torchIsOn = false {
        didSet {
            try? camera.toggleTorch(on: torchIsOn)
        }
    }
    var isPhotosLoaded = false

    let camera = Camera()
    let library = PhotoCollection()

    // MARK: - Private Properties

    private let recognizer = ImageTextRecognizer()

    // MARK: - Init

    init() {
        Task {
            await handleCameraPreviews()
        }
        Task {
            await handleCameraPhotos()
        }
    }

    // MARK: - Public Methods

    func loadPhotos() async {
        guard !isPhotosLoaded else { return }

        try? await PhotoLibrary.checkAuthorization()

        Task {
            do {
                try await library.load()
                await loadThumbnail()
            } catch let error {
                print(error)
            }
            isPhotosLoaded = true
        }
    }

    func loadThumbnail() async {
        guard let asset = library.photoAssets.first  else { return }

        await library.cache.requestImage(for: asset, targetSize: CGSize(width: 256, height: 256)) { result in
            if let result {
                Task { @MainActor in
                    self.libraryThumbnail = Image(uiImage: result.image)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                preview = image
            }
        }
    }

    private func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { $0.fileDataRepresentation() }

        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                originalImage = .init(data: photoData)
            }
        }
    }

    @MainActor
    private func translate() async {
        guard let originalImage else { return }

        isTranslating = true

        do {
            translatedImage = try await recognizer.recognizeText(onImage: originalImage, languages: languages)
            isShowOriginalPhoto = false
        } catch  {
            print(error)
        }
        isTranslating = false
    }
}


fileprivate extension CIImage {

    var image: Image? {
        let ciContext = CIContext()

        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }

        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
