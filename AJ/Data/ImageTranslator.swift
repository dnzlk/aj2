//
//  ImageTranslator.swift
//  AJ
//
//  Created by Денис on 07.10.2023.
//

import Foundation

final class ImageTranslator: APIEndpoint {

    // MARK: - Types

    typealias ImageData = [ImageTextRecognizer.Data]

    enum E: Error {
        case wrongUrl
        case unknownLanguage
    }

    // MARK: - Public Properties

    override var debugUrl: String? {
        "http://127.0.0.1:3000/ask"
    }

    override var prodUrl: String? {
        "http://165.232.91.100:80/ask"
    }

    // MARK: - Public Methods

    func translate(imageData: ImageData, languages: Languages) async throws -> ImageData {

        let splitCount = 10

        let lines = imageData.enumerated().map { i, item in
            return "\(i). \(item.string)\n"
        }

        let arrayOfLines = lines.splitIntoChunks(of: splitCount).map { $0.joined() }

        let translatedLines = await makeLinesRequest(arrayOfLines, languages)

        let splittedData = imageData.splitIntoChunks(of: splitCount)

        guard translatedLines.count == splittedData.count else { return [] }

        var translatedImageData: [ImageData] = []

        for i in 0..<splittedData.count {
            var originalData = splittedData[i]
            let translatedStrings = translatedLines[i]
            for j in 0..<originalData.count {
                guard j < translatedStrings.count else { break }

                originalData[j].string = translatedStrings[j]
            }
            translatedImageData.append(originalData)
        }
        return translatedImageData.reduce(into: [], { $0 += $1 })
    }

    private func makeLinesRequest(_ arrayOfLines: [String], _ languages: Languages) async -> [[String]] {
        let requestData: [(Int, String)] = arrayOfLines.enumerated().map { i, lines in
            (i, lines)
        }
        let translatedStrings = await withTaskGroup(of: (Int, [String]).self) { group -> [[String]] in
            for data in requestData {
                group.addTask { [weak self] in
                    let translatedLines = (try? await self?.translate(line: data.1, languages: languages)) ?? ""
                    let array = self?.parse(imageTextTranslate: translatedLines) ?? []

                    return (data.0, array)
                }
            }

            var translations = await group.reduce(into: [(Int, [String])]()) { partialResults, translation in
                partialResults.append(translation)
            }
            translations.sort { $0.0 < $1.0 }

            return translations.map { $0.1 }
        }
        return translatedStrings
    }

    private func translate(line: String, languages: Languages) async throws -> String {

        guard let url else { throw E.wrongUrl }

        let amMessages: [AMChatMessage] = [
            .init(role: "user", content: "Translate line by line from \(languages.from.englishName) to \(languages.to.englishName) (response must contain same amount of lines): \(line)")
        ]
        let amChat = AMChat(messages: amMessages)
        let encodedAmChat = try JSONEncoder().encode(amChat)

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedAmChat
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AMChatResponse.self, from: data)

        return response.content
    }

    private func parse(imageTextTranslate: String) -> [String] {
        let lines = imageTextTranslate.components(separatedBy: "\n")
        var texts: [String] = []

        for line in lines {
            let components = line.components(separatedBy: ". ")
            if let first = components.first, components.count > 1, Int(first) != nil {
                let cleanedString = components[1..<components.count].joined(separator: ". ")
                texts.append(cleanedString)
            } else {
                texts.append(line)
            }
        }
        return texts
    }
}

extension Array {

    func splitIntoChunks(of chunkSize: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        stride(from: 0, to: count, by: chunkSize).forEach { startIndex in
            let endIndex = startIndex + chunkSize > count ? count : startIndex + chunkSize
            chunks.append(Array(self[startIndex..<endIndex]))
        }
        return chunks
    }
}
