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
    private let pm = PurchaseManager.shared
    private let ud = UserDefaultsManager.shared
    private let freeMessagesStorage = SecureStore(secureStoreQueryable: GenericPasswordQueryable(key: .numberOfMessagesLeftToday))

    private var isFirstAppearance = true
    private var isJoeTyping = false
    private var isError = false
    private var usersLastMessage: String?
    private var version: String?

    private var chat: Chat?
    private var prompt: Prompt?
    private var person: Person?

    // MARK: - Init

    init(chat: Chat? = nil, prompt: Prompt? = nil, person: Person? = nil) {
        self.chat = chat
        self.prompt = prompt
        self.person = person
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard isFirstAppearance && person == nil && prompt == nil else {
            isFirstAppearance = false
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.chatView.becomeFirstResponder()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        registerForRemoteNotifications()
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
        } else if let prompt { // TODO: REMOVE FROM HERE!!!!!!!
            newCells = [.prompt(prompt)]
            Task {
                await send(text: prompt.text)
            }
        } else if person == nil {
            newCells = dm.getDailyPrompts().map { .prompt($0) }
        }
        chatView.model = .init(newCells: newCells.reversed(), person: chat?.person ?? person)
    }

    private func addChatView() {
        view.addSubview(chatView)
        chatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func send(text: String, isNewMessage: Bool = true) async {
        if chat == nil {
            guard let _chat = await dm.createChat(person: person) else { return } // TODO: Popup error
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

        // Payment check
        var hasDecreasedFreeMessagesCount = false

        if !pm.hasUnlockedFullAccess && !ud.isDebugMode() {
            let freeMessagesLeft = Int((try? freeMessagesStorage.getValue()?.0) ?? "0") ?? 0

            if freeMessagesLeft > 0 {
                try? freeMessagesStorage.set(value: "\(freeMessagesLeft - 1)")
                hasDecreasedFreeMessagesCount = true
            } else {
                openPayment()
                FBAnalytics.log(.chat_show_payment)
                return
            }
        }
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

            if hasDecreasedFreeMessagesCount {
                let freeMessagesLeft = Int((try? freeMessagesStorage.getValue()?.0) ?? "0") ?? 0
                try? freeMessagesStorage.set(value: "\(freeMessagesLeft + 1)")
            }
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

    private func registerForRemoteNotifications() {
        let application = UIApplication.shared

        guard let appDelegate = application.delegate as? AppDelegate else { return }

        if ud.getStartingDay() != 0 {
            UNUserNotificationCenter.current().delegate = appDelegate

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions) { _, _ in }

            application.registerForRemoteNotifications()
        }
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
