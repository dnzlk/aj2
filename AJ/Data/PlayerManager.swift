//
//  Player.swift
//  AJ
//
//  Created by Денис on 11.09.2023.
//

import AVFoundation
import SwiftData
import SwiftUI

final class PlayerManager: NSObject, AVSpeechSynthesizerDelegate {

    enum E: Error {
        case noAvailableVoices
    }

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Private Properties

    private let synthesizer = AVSpeechSynthesizer()

    private var playingMessage: Message?

    private var context: ModelContext?

    // MARK: - Public Methods

    func play(message: Message, context: ModelContext) {
        guard let translation = message.translation else { return }

        stop()

        let utterance = AVSpeechUtterance(string: translation.text)

        utterance.voice = AVSpeechSynthesisVoice(language: translation.language)
        synthesizer.speak(utterance)

        playingMessage = message

        withAnimation {
            message.isPlaying = true

            try? context.save()
        }

        self.context = context
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
        withAnimation {
            clear()
            try? context?.save()
        }
        context = nil
    }
}
