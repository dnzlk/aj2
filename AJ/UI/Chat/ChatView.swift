//
//  ChatView.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import SnapKit
import DifferenceKit
import UIKit

final class _ChatView: _View<_ChatView.Model, _ChatView.Action> {

    // MARK: - Types

    struct Model {

        var newCells: [ChatCellModel] = []
        var textFieldPlaceholder: String = ""

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

        case copyTap(Message)
        case voiceTap(Message)
        case favTap(Message)
        case originalTextTap(Message)

        case errorTap(Message)
    }

    private enum Const {
        static let shouldHideKeyboardOffset: CGFloat = 100.0
    }

    // MARK: - Private Properties

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.transform = CGAffineTransformMakeScale(1, -1)
        table.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseId)
        table.showsVerticalScrollIndicator = false
        return table
    }()

    private let textField = ChatTextField(model: .init(placeholder: ""))

    private var cells: [ChatCellModel] = []

    private var lastScrollOffset: CGFloat = 0
    private var lastTimeScrollWentDownOffset: CGFloat = 0

    private var isTextFieldActive = false

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        addSubview(tableView)
        addSubview(textField)
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        super.setupConstraints()
    }

    override func bind() {
        textField.onAction = { [weak self] action in
            switch action {
            case .onBecomeActive:
                self?.isTextFieldActive = true
                self?.lastTimeScrollWentDownOffset = self?.tableView.contentOffset.y ?? 0
            case .onBecomeInactive:
                self?.isTextFieldActive = false
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
        textField.model?.placeholder = model.textFieldPlaceholder

        let oldCells = cells
        cells = model.newCells

        let diff = StagedChangeset(source: oldCells, target: cells)
        
        tableView.reload(using: diff, with: .fade) { [weak self] data in
            self?.cells = data
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
}

// MARK: - UITableViewDataSource

extension _ChatView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let item = cells[indexPath.row]

        switch item {
        case let .message(message, style):
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as? MessageCell
            else {
                return cell
            }
            messageCell.model = .init(message: message, style: style)
            messageCell.onAction = { [weak self] action in
                switch action {
                case .errorTap:
                    self?.onAction?(.errorTap(message))
                case .copyTap:
                    self?.onAction?(.copyTap(message))
                case .favTap:
                    self?.onAction?(.favTap(message))
                case .voiceTap:
                    self?.onAction?(.voiceTap(message))
                case .originalTextTap:
                    self?.onAction?(.originalTextTap(message))
                }
            }
            cell = messageCell
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

extension _ChatView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let model, case .message(let message, _) = model.newCells[indexPath.row] else { return nil }

        guard let text = message.translation else { return nil }

        return .init(identifier: "\(indexPath.row)" as NSString,
                     previewProvider: nil) { _ in
            let shareAction = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                    self?.onAction?(.share(text))
                }
            return UIMenu(title: "", image: nil, children: [shareAction])
        }
    }

    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
          let identifier = configuration.identifier as? String,
          let index = Int(identifier),
          let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MessageCell else {
            return nil
        }
        return UITargetedPreview(view: cell.translationBgContainer)
    }
}

// MARK: - UIScrollViewDelegate

extension _ChatView: UIScrollViewDelegate {

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
