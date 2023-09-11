//
//  Player.swift
//  AJ
//
//  Created by Денис on 11.09.2023.
//

import AVFoundation
import Foundation

final class PlayerManager: NSObject, AVSpeechSynthesizerDelegate {

    enum E: Error {
        case noAvailableVoices
    }

    static let shared = PlayerManager()

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Private Properties

    private let synthesizer = AVSpeechSynthesizer()

    private var onFinish: (() -> Void)?

    // MARK: - Public Methods

    func play(text: String, language: String? = "en", onFinish: (() -> Void)? = nil) throws {
        stop()

        let utterance = AVSpeechUtterance(string: text)

        utterance.voice = AVSpeechSynthesisVoice(language: language)
        synthesizer.speak(utterance)

        self.onFinish = onFinish
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinish?()
    }
}
