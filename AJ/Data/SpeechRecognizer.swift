//
//  SpeechRecognizer.swift
//  AJ
//
//  Created by Денис on 12.09.2023.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI


/// https://developer.apple.com/tutorials/app-dev-training/transcribing-speech-to-text

final actor SpeechRecognizer: ObservableObject {

    // MARK: - Types

    enum E: Error {
        case unknown
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
    }

    // MARK: - Public Properties

    @MainActor var transcript: String = ""

    // MARK: - Private Properties

    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?


    // MARK: - Public Methods

    @MainActor
    func startTranscribing(locale: String) async throws {
        guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
            throw E.notAuthorizedToRecognize
        }
        guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
            throw E.notPermittedToRecord
        }
        try await transcribe(locale: locale)
    }

    @MainActor
    func resetTranscript() async {
        await reset()
    }

    @MainActor
    func stopTranscribing() async {
        await reset()
    }

    // MARK: - Private Methods
    
    private func transcribe(locale: String) throws {
        guard let recognizer = SFSpeechRecognizer(locale: .init(identifier: locale)), recognizer.isAvailable else {
            throw E.recognizerIsUnavailable
        }
        let (audioEngine, request) = try Self.prepareEngine()
        self.audioEngine = audioEngine
        self.request = request
        self.task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
            self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
        })
    }

    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }

    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()

        return (audioEngine, request)
    }

    nonisolated private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil

        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        if let result {
            transcribe(result.bestTranscription.formattedString.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }

    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            transcript = message
        }
    }
}


extension SFSpeechRecognizer {

    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}


extension AVAudioSession {

    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
