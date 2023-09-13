//
//  ChatController.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import SwiftUI
import UIKit
import AVFoundation

struct ChatView: UIViewControllerRepresentable {

    @Binding var voiceText: String
    let languages: Languages
    let onVoicePressed: () -> Void

    func makeUIViewController(context: Context) ->ChatController {
        ChatController(languages: languages, onVoicePressed: onVoicePressed)
    }

    func updateUIViewController(_ uiViewController: ChatController, context: Context) {
        uiViewController.voiceText = voiceText
    }
}

final class ChatController: _ViewController {

    // MARK: - Types

    private enum TranslationStatus: String {
        case loading
        case failed
    }

    // MARK: - Public Properties

    var voiceText: String = "" {
        didSet {
            Task { await send(text: voiceText) }
        }
    }

    let onVoicePressed: (() -> Void)

    // MARK: - Private Properties

    private let chatView = _ChatView()

    private var languages: Languages

    private let te = TranslateEndpoint.shared
    private let mm = MessagesManager.shared
    private let ud = UserDefaultsManager.shared
    private let player = PlayerManager.shared

    private var pendingMessage: Message?
    private var failedMessage: Message?
    private var playingMessage: Message?

    // MARK: - Init

    init(languages: Languages, onVoicePressed: @escaping (() -> Void)) {
        self.languages = languages
        self.onVoicePressed = onVoicePressed

        super.init()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addChatView()
        reloadTable()
    }

    override func bind() {
        chatView.onAction = { [weak self] action in
            switch action {
            case let .errorTap(message):
                Task {
                    await self?.send(text: message.originalText)
                }
            case let .share(text):
                self?.share(text: text)
                FBAnalytics.log(.chat_share_message_tap)
            case let .sendButtonTapped(text):
                Task {
                    await self?.send(text: text)
                }
            case .micTap:
                self?.onVoicePressed()

            case let .copyTap(message):
                UIPasteboard.general.string = message.translation
            case let .favTap(message):
                self?.toggleIsFav(message: message)
            case let .voiceTap(message):
                self?.play(message: message)
            case let .originalTextTap(message):
                break
            }
        }
        super.bind()
    }

    // MARK: - Private Methods

    private func addChatView() {
        view.addSubview(chatView)
        chatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func reloadTable() {
        var models: [ChatCellModel] = mm.get().filter { $0.translation != nil }.map { message in
            let style: MessageCell.Style = {
                guard let code = message.language else {
                    return .right(language: .english, isPlaying: message.id == playingMessage?.id)
                }
                if code == languages.0.rawValue {
                    return .left(language: languages.0, isPlaying: message.id == playingMessage?.id)
                }
                if code == languages.1.rawValue {
                    return .right(language: languages.1, isPlaying: message.id == playingMessage?.id)
                }
                return .right(language: .english, isPlaying: message.id == playingMessage?.id)
            }()
            return .message(message: message, style: style )
        }

        if let pendingMessage {
            models.append(.message(message: pendingMessage, style: .loading))
        } else if let failedMessage {
            models.append(.message(message: failedMessage, style: .error))
        }
        chatView.model = .init(newCells: models.reversed(),
                               textFieldPlaceholder: "\(languages.0.typeHereText) / \(languages.1.typeHereText)")
    }

    private func send(text: String) async {
        failedMessage = nil

        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        FBAnalytics.log(.chat_send_tap)

        chatView.clear()

        let message = Message(originalText: text, date: Date(), additionalInfo: TranslationStatus.loading.rawValue)
        pendingMessage = message

        reloadTable()

        do {
            let translation = try await te.translate(text: text, languages: languages)
            let translatedMessage = Message(originalText: text,
                                            translation: translation.text,
                                            date: message.date,
                                            language: translation.language,
                                            additionalInfo: nil)
            mm.save(translatedMessage)

            pendingMessage = nil
            reloadTable()
        } catch {
            failedMessage = Message(originalText: message.originalText,
                                    date: message.date,
                                    additionalInfo: TranslationStatus.failed.rawValue)
            pendingMessage = nil
            reloadTable()
            FBAnalytics.log(.chat_error)
        }
    }

    private func play(message: Message) {
        guard let text = message.translation else { return }

        do {
            try player.play(text: text, language: message.language) { [weak self] in
                self?.playingMessage = nil
                self?.reloadTable()
            }
            playingMessage = message
            reloadTable()
        } catch let e as PlayerManager.E {
            print(e)
        } catch {

        }
    }

    private func toggleIsFav(message: Message) {
        mm.update(isFav: !message.isFav, message: message)
        reloadTable()
    }

    private func share(text: String) {
        chatView.endEditing(true)

        share(items: [text])
    }
}
