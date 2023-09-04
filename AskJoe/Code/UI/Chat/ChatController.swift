//
//  ChatController.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import UIKit

final class ChatController: ViewController {

    // MARK: - Public Properties

    var onBackPressed: (() -> Void)?

    // MARK: - Private Properties

    private let chatView = ChatView()

    private let dm = DataManager.shared
    private let nm = NotificationsManager.shared
    private let ud = UserDefaultsManager.shared

    private var isJoeTyping = false
    private var isError = false
    private var usersLastMessage: String?
    private var version: String?

    private var chat: Chat?
    
    // MARK: - Init

    init(chat: Chat? = nil) {
        self.chat = chat
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

    private func reloadTable() {
        var newCells: [ChatCellModel] = []
        
        if let chat {
            newCells = chat.messages.map { .message($0) }

            if isJoeTyping {
                newCells.append(.joeIsTyping)
            } else if isError {
                newCells.append(.tryAgainError)
            }
        }
        chatView.model = .init(newCells: newCells.reversed())
    }

    private func addChatView() {
        view.addSubview(chatView)
        chatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func send(text: String, isNewMessage: Bool = true) async {
        if chat == nil {
            guard let _chat = await dm.createChat() else { return } // TODO: Popup error
            chat = _chat
        }
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        usersLastMessage = text

        guard !text.isEmpty,
              !isJoeTyping,
              let chat
        else {
            return
        }
        FBAnalytics.log(.chat_send_tap)

        chatView.clear()

        do {
            isJoeTyping = true

            if isError {
                isError = false
                reloadTable()
            }
            _ = try await dm.sendMessage(text: text, chat: chat, version: version, isNewMessage: isNewMessage)
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
        version = "3.5"
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
        case let .chatUpdated(chat):
            guard chat.id == self.chat?.id else { return }

            self.chat = chat

            DispatchQueue.main.async {
                self.reloadTable()
            }
        default:
            break
        }
    }
}
