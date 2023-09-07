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

        let style: Style
    }

    enum Action {
        case tap
    }

    enum Style {
        case message(Message)
    }

    // MARK: - Public Properties

    let container = UIView()

    // MARK: - Private Properties

    private let label: UILabel = {
        let view = UILabel()
        view.font = .regular(14)
        view.numberOfLines = 0
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        addSubview(container)
        container.addSubview(label)
        container.isUserInteractionEnabled = true

        backgroundColor = UIColor(Assets.Colors.white)
        selectionStyle = .none
        container.roundCorners(12)
    }

    override func setupConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
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

        switch model.style {
        case let .message(message):
            label.text = message.text

            if message.isUserMessage {
                container.snp.remakeConstraints { make in
                    make.top.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview().inset(8)
                    make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
                }
                container.backgroundColor = UIColor(Assets.Colors.accentColor)
                label.textColor = Assets.Colors.textOnAccent
            } else {
                container.snp.remakeConstraints { make in
                    make.left.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview().inset(8)
                    make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
                }
                container.backgroundColor = Assets.Colors.solidWhite
                label.textColor = Assets.Colors.black
            }
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
