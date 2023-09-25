//
//  Player.swift
//  AJ
//
//  Created by Денис on 11.09.2023.
//

import AVFoundation
import SwiftUI

final class PlayerManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    enum E: Error {
        case noAvailableVoices
    }

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Private Properties

    private let synthesizer = AVSpeechSynthesizer()

    @Published private var playingMessage: Message?

    // MARK: - Public Methods

    func play(message: Message) {
        guard let translation = message.translation else { return }

        stop()

        let utterance = AVSpeechUtterance(string: translation.text)

        utterance.voice = AVSpeechSynthesisVoice(language: translation.language)
        synthesizer.speak(utterance)

        message.isPlaying = true

        _playingMessage = Published(initialValue: message)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        clear()
    }

    private func clear() {
        playingMessage?.isPlaying = false
        playingMessage = nil
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        clear()
    }
}
