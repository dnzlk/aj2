//
//  ChatView.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import DifferenceKit
import UIKit

final class ChatView: View<ChatView.Model, ChatView.Action> {

    // MARK: - Types

    struct Model {

        var newCells: [ChatCellModel] = []
        var person: Person? = nil

        var hasMessages: Bool {
            newCells.contains(where: {
                if case .message = $0 {
                    return true
                }
                return false
            })
        }
    }

    enum Action {
        case backButtonTapped
        case share(String)
        case sendButtonTapped(String)
        case tryAgainTapped
    }

    private enum Const {
        static let shouldHideKeyboardOffset: CGFloat = 100.0
    }

    // MARK: - Private Properties

    private let navBar = NavBar()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = Assets.Colors.white
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.transform = CGAffineTransformMakeScale(1, -1)
        table.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseId)
        table.register(JoeIsTypingCell.self, forCellReuseIdentifier: JoeIsTypingCell.reuseId)
        table.register(TryAgainCell.self, forCellReuseIdentifier: TryAgainCell.reuseId)
        table.showsVerticalScrollIndicator = false
        return table
    }()

    private let chatPersonPromptsView = ChatPersonPromptsView()

    private let textField = ChatTextField(model: .init(placeholder: L10n.Chat.typeYourQuestion))

    private var cells: [ChatCellModel] = []

    private var lastScrollOffset: CGFloat = 0
    private var lastTimeScrollWentDownOffset: CGFloat = 0

    private var isTextFieldActive = false

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = Assets.Colors.white

        addSubview(navBar)
        addSubview(tableView)
        addSubview(textField)
        addSubview(chatPersonPromptsView)
    }

    override func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(navBar.snp.bottom)
        }
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        chatPersonPromptsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        super.setupConstraints()
    }

    override func bind() {
        navBar.onAction = { [weak self] action in
            switch action {
            case .backButtonTap:
                self?.onAction?(.backButtonTapped)
            case .rightButtonTap:
                break
            }
        }
        textField.onAction = { [weak self] action in
            switch action {
            case .onBecomeActive:
                self?.isTextFieldActive = true
                self?.updateCharacterPromptsVisibility(animated: true)
                self?.lastTimeScrollWentDownOffset = self?.tableView.contentOffset.y ?? 0
            case .onBecomeInactive:
                self?.isTextFieldActive = false
                self?.updateCharacterPromptsVisibility(animated: true)
            case let .sendButtonTap(text):
                self?.onAction?(.sendButtonTapped(text))
                self?.tableView.setContentOffset(.zero, animated: true)
            }
        }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onChatTap))
        tapRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapRecognizer)

        super.bind()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        let oldCells = cells
        cells = model.newCells

        let diff = StagedChangeset(source: oldCells, target: cells)
        
        tableView.reload(using: diff, with: .fade) { [weak self] data in
            self?.cells = data
        }
        if let person = model.person {
            navBar.model = .init(title: .attributed(generateAskPersonString(person)),
                                 avatarURL: person.avatarUrl,
                                 backgroundColor: Assets.Colors.white,
                                 backButtonImage: .init(named: "arrowBack"))
            updateCharacterPromptsVisibility()
            chatPersonPromptsView.model = person
            chatPersonPromptsView.onAction = { [weak self] action in
                switch action {
                case let .tap(prompt):
                    self?.onAction?(.sendButtonTapped(prompt))
                }
            }
        } else {
            navBar.model = .init(backgroundColor: Assets.Colors.white, backButtonImage: .init(named: "arrowBack"))
            chatPersonPromptsView.isHidden = true
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Public Methods

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()

        return true
    }

    func clear() {
        textField.clear()
    }

    // MARK: - Private Methods

    @objc
    private func onChatTap() {
        endEditing(true)
    }

    private func generateAskPersonString(_ person: Person) -> NSAttributedString {
        let string = L10n.Chat.ask(person.name)
        let attributedString = NSMutableAttributedString(string: string)
        let attrs = [NSAttributedString.Key.font : UIFont.bold(18).boldItalic]
        let range = (string as NSString).range(of: person.name)
        attributedString.addAttributes(attrs, range: range)

        return attributedString
    }

    private func updateCharacterPromptsVisibility(animated: Bool = false) {
        guard let model, let person = model.person else {
            chatPersonPromptsView.alpha = 0
            return
        }
        let isHidden = !model.newCells.isEmpty || person.prompts.isEmpty || isTextFieldActive

        if animated {
            UIView.animate(withDuration: 0.2) {
                self.chatPersonPromptsView.alpha = isHidden ? 0 : 1
            }
        } else {
            chatPersonPromptsView.alpha = isHidden ? 0 : 1
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let item = cells[indexPath.row]

        switch item {
        case .joeIsTyping:
            guard let joeCell = tableView.dequeueReusableCell(withIdentifier: JoeIsTypingCell.reuseId, for: indexPath) as? JoeIsTypingCell else {
                return cell
            }
            let typingModel: JoeIsTypingCell.Model = {
                if let person = model?.person {
                    return .custom(person.name)
                }
                return .joe
            }()
            joeCell.model = .init(typingModel)
            cell = joeCell
        case let .message(message):
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as? MessageCell
            else {
                return cell
            }
            messageCell.model = .init(style: .message(message))
            messageCell.onAction = nil
            cell = messageCell
        case let .prompt(prompt):
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as? MessageCell else {
                return cell
            }
            messageCell.model = .init(style: .prompt(prompt))
            messageCell.onAction = { [weak self] action in
                switch action {
                case .tap:
                    self?.onAction?(.sendButtonTapped(prompt.text))
                    FBAnalytics.log(.chat_prompt_tap)
                }
            }
            cell = messageCell
        case .tryAgainError:
            guard let tryAgainCell = tableView.dequeueReusableCell(withIdentifier: TryAgainCell.reuseId, for: indexPath) as? TryAgainCell else {
                return cell
            }
            tryAgainCell.onAction = { [weak self] action in
                switch action {
                case .tap:
                    self?.onAction?(.tryAgainTapped)
                }
            }
            cell = tryAgainCell
        }
        cell.transform = CGAffineTransformMakeScale(1, -1)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
}

// MARK: - UITableViewDelegate

extension ChatView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let model, case .message(let message) = model.newCells[indexPath.row] else { return nil }

        let text = message.text

        return .init(identifier: "\(indexPath.row)" as NSString,
                     previewProvider: nil) { _ in
            let copyAction = UIAction(
                title: L10n.Chat.copy,
                image: UIImage(systemName: "doc.on.doc")) { _ in
                    UIPasteboard.general.string = text
                    FBAnalytics.log(.chat_copy_message_tap)
                }

            let shareAction = UIAction(
                title: L10n.Chat.share,
                image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                    self?.onAction?(.share(text))
                }
            return UIMenu(title: "", image: nil, children: [copyAction, shareAction])
        }
    }

    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
          let identifier = configuration.identifier as? String,
          let index = Int(identifier),
          let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MessageCell else {
            return nil
        }
        return UITargetedPreview(view: cell.container)
    }
}

// MARK: - UIScrollViewDelegate

extension ChatView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newOffset = scrollView.contentOffset.y
        let scrollWentUp = newOffset > lastScrollOffset

        if scrollWentUp {
            if newOffset - lastTimeScrollWentDownOffset > Const.shouldHideKeyboardOffset {
                UIView.animate(withDuration: 0.25) {
                    self.endEditing(true)
                }
            }
        } else {
            lastTimeScrollWentDownOffset = newOffset
        }
        lastScrollOffset = newOffset
    }
}
