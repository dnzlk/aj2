//
//  MessageCell.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import UIKit

final class MessageCell: Cell<MessageCell.Model, MessageCell.Action> {

    static let reuseId = String(describing: MessageCell.self)

    // MARK: - Types

    struct Model {

        let message: Message
    }

    enum Action {
        case tap
    }

    // MARK: - Public Properties

    let container = UIView()

    // MARK: - Private Properties

    private let translationLabel: UILabel = {
        let view = UILabel()
        view.font = .medium(18)
        view.numberOfLines = 0
        return view
    }()
    

    private let originalTextLabel: UILabel = {
        let view = UILabel()
        view.font = .regular(14)
        view.textColor = Assets.Colors.dark
        view.numberOfLines = 3
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        addSubview(container)
        container.addSubview(translationLabel)
        addSubview(originalTextLabel)
        container.isUserInteractionEnabled = true

        backgroundColor = UIColor(Assets.Colors.white)
        selectionStyle = .none
        container.roundCorners(12)
    }

    override func setupConstraints() {
        translationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        originalTextLabel.snp.remakeConstraints { make in
            make.left.right.equalTo(container)
            make.top.equalTo(container.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(24)
        }
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        backgroundColor = UIColor(Assets.Colors.white)

        let message = model.message

        translationLabel.text = message.translation
        originalTextLabel.text = message.originalText

        if message.isUserMessage {
            container.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            }
            originalTextLabel.textAlignment = .right
            container.backgroundColor = UIColor(Assets.Colors.accentColor)
            translationLabel.textColor = Assets.Colors.textOnAccent
        } else {
            container.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            }
            originalTextLabel.textAlignment = .left
            container.backgroundColor = Assets.Colors.solidWhite
            translationLabel.textColor = Assets.Colors.black
        }

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
