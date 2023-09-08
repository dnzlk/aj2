//
//  ChatController.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import SwiftUI
import UIKit

struct ChatView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) ->ChatController {
        ChatController()
    }

    func updateUIViewController(_ uiViewController: ChatController, context: Context) {
        
    }
}

final class ChatController: _ViewController {

    // MARK: - Public Properties

    var onBackPressed: (() -> Void)?

    // MARK: - Private Properties

    private let chatView = _ChatView()

    private let te = TranslateEndpoint.shared
    private let mm = MessagesManager.shared
    private let nm = NotificationsManager.shared
    private let ud = UserDefaultsManager.shared

    private var isError = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addChatView()
        reloadTable()

        nm.addObserver(self)
    }

    override func bind() {
        chatView.onAction = { [weak self] action in
            switch action {
            case let .share(text):
                self?.share(text: text)
                FBAnalytics.log(.chat_share_message_tap)
            case .backButtonTapped:
                self?.navigationController?.popViewController(animated: true)
                self?.onBackPressed?()
            case let .sendButtonTapped(text):
                Task {
                    await self?.send(text: text)
                }
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
        var models: [ChatCellModel] = mm.get().map { .message($0) }

        if isError {
            models.append(.error)
        }
        chatView.model = .init(newCells: models.reversed())
    }

    private func send(text: String) async {
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        FBAnalytics.log(.chat_send_tap)

        chatView.clear()

        let message = Message(originalText: text, date: Date(), isUserMessage: true)
        mm.save(message)

        do {
            reloadTable()

            if isError {
                isError = false
                reloadTable()
            }
            let translation = try await te.translate(text: text)
            mm.update(message: message, withTranslation: translation)
            reloadTable()
        } catch {
            isError = true
            reloadTable()
            FBAnalytics.log(.chat_error)
        }
    }

    private func share(text: String) {
        chatView.endEditing(true)

        share(items: [text])
    }
}

// MARK: - NotificationsObserver

extension ChatController: NotificationsObserver {

    func onEvent(_ event: NotificationsManager.Event) {
        switch event {
        case .subscriptionInfoUpdated:
            break
        }
    }
}
