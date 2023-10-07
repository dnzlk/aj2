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

    enum E: Error {
        case brokenImage
        case failedObservations
        case failedBoundingBoxDrawing
    }

    func recognizeText(onImage image: UIImage, languages: Languages) async throws -> UIImage {
        guard let cgImage = resize(image: image, to: size(of: image))?.cgImage else { throw E.brokenImage }

        let data: [Data] = try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: E.failedObservations)
                    return
                }
                let extractedData: [Data] = observations.map { .init(string: $0.topCandidates(1).first?.string ?? "", box: $0.boundingBox) }
                continuation.resume(returning: extractedData)
            }
            request.recognitionLevel = .accurate
            let requests = [request]
            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try imageRequestHandler.perform(requests)
            } catch {
                continuation.resume(throwing: error)
            }
        }
        let translatedData = try await ImageTranslator().translate(imageData: data, languages: languages)

        if let updatedImage = drawBoundingBoxes(on: image, data: translatedData) {
            return updatedImage
        } else {
            throw E.failedBoundingBoxDrawing
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
