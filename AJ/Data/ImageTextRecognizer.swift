//
//  ImageTextRecognizer.swift
//  AJ
//
//  Created by Денис on 06.10.2023.
//

import Vision
import UIKit
import SwiftUI

final class ImageTextRecognizer {

    struct Data {

        var string: String
        let box: CGRect
    }

    @Binding var image: UIImage

    init(image: Binding<UIImage>) {
        self._image = image
    }

    func recognizeText() {
        guard let cgImage = resize(image: image, to: size(of: image))?.cgImage else { return }

        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let self, let observations = request.results as? [VNRecognizedTextObservation] else { return }

            Task {
                let data: [Data] = observations.map { .init(string: $0.topCandidates(1).first?.string ?? "", box: $0.boundingBox) }

                let translatedData = (try? await ImageTranslator.shared.translate(imageData: data, languages: .init(from: .english, to: .chineseSimplified), textLanguage: .english)) ?? data

                DispatchQueue.main.async {
                    if let updatedImage = self.drawBoundingBoxes(on: self.image, data: translatedData) {
                        self.image = updatedImage
                    }
                }

            }
        }
        request.recognitionLevel = .accurate

        let requests = [request]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("Failed to perform image request: \(error.localizedDescription)")
        }
    }

    private func drawBoundingBoxes(on originalImage: UIImage, data: [Data]) -> UIImage? {
        let desiredSize = size(of: originalImage)

        UIGraphicsBeginImageContextWithOptions(desiredSize, false, 0)
        defer { UIGraphicsEndImageContext() }

        originalImage.draw(in: CGRect(origin: .zero, size: desiredSize))

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        for item in data {
            let box = item.box
            let transformedRect = CGRect(x: box.minX * desiredSize.width,
                                         y: (1 - box.maxY) * desiredSize.height,
                                         width: box.width * desiredSize.width,
                                         height: box.height * desiredSize.height)
            context.setFillColor(UIColor.gray.cgColor)
            context.fill(transformedRect)

            let text = item.string
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize(for: text, within: transformedRect)),
                .foregroundColor: UIColor.black
            ]
            text.draw(in: transformedRect, withAttributes: textAttributes)
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private func size(of image: UIImage) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = screenWidth / image.size.width

        return CGSize(width: screenWidth, height: image.size.height * scaleFactor)
    }

    func resize(image: UIImage, to newSize: CGSize) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }

    private func fontSize(for string: String, within rect: CGRect) -> CGFloat {
        let maxFontSize: CGFloat = 36.0
        let minFontSize: CGFloat = 8.0

        var fontSize = maxFontSize

        while size(string, fontSize).width > rect.width || size(string, fontSize).height > rect.height {
            fontSize -= 1.0
            if fontSize < minFontSize {
                fontSize = minFontSize
                break
            }
        }
        return fontSize
    }

    private func size(_ string: String, _ fontSize: CGFloat) -> CGSize {
        string.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
    }
}
