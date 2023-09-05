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

    private let chatEndpoint = ChatEndpoint.shared
    private let nm = NotificationsManager.shared
    private let ud = UserDefaultsManager.shared

    private var isJoeTyping = false
    private var isError = false
    private var usersLastMessage: String?

    private var messages: [Message] = []

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
            case .tryAgainTapped:
                Task {
                    await self?.tryAgain()
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
        var newCells: [ChatCellModel] = messages.map { .message($0) }

        if isJoeTyping {
            newCells.append(.joeIsTyping)
        } else if isError {
            newCells.append(.tryAgainError)
        }
        chatView.model = .init(newCells: newCells.reversed())
    }

    private func send(text: String, isNewMessage: Bool = true) async {
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        usersLastMessage = text

        guard !text.isEmpty, !isJoeTyping else { return }

        FBAnalytics.log(.chat_send_tap)

        chatView.clear()

        if isNewMessage {
            messages.append(.init(id: UUID().uuidString,
                                  text: text,
                                  date: Date(),
                                  isUserMessage: true))
        }

        do {
            isJoeTyping = true
            reloadTable()

            if isError {
                isError = false
                reloadTable()
            }
            let response = try await chatEndpoint.ask(request: text, messages: messages)
            messages.append(.init(id: UUID().uuidString,
                                  text: response,
                                  date: Date(),
                                  isUserMessage: false))
            isJoeTyping = false
            reloadTable()
        } catch {
            isError = true
            isJoeTyping = false
            reloadTable()
            FBAnalytics.log(.chat_error)
        }
    }

    private func tryAgain() async {
        guard let usersLastMessage else {
            isError = false
            reloadTable()
            return
        }
        await send(text: usersLastMessage, isNewMessage: false)
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
