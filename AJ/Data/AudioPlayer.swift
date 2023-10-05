//
//  AudioPlayer.swift
//  AJ
//
//  Created by Денис on 11.09.2023.
//

import AVFoundation
import SwiftUI

final class AudioPlayer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    enum E: Error {
        case noAvailableVoices
    }

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Private Properties

    private let synthesizer = AVSpeechSynthesizer()

    @Published private(set) var playingMessageId: String?

    private var currentUtterance: AVSpeechUtterance?

    // MARK: - Public Methods

    func play(message: Message) {
        guard let translation = message.translation else { return }

        stop()

        let utterance = AVSpeechUtterance(string: translation.text)

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default, options: [.defaultToSpeaker])

        utterance.voice = AVSpeechSynthesisVoice(language: translation.language)
        synthesizer.speak(utterance)
        currentUtterance = utterance

        playingMessageId = message.id
    }

    func stop() {
        playingMessageId = nil
        currentUtterance = nil
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - AVSpeechSynthesizerDelegate

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard currentUtterance == utterance else { return }

        currentUtterance = nil
        playingMessageId = nil
    }
}
