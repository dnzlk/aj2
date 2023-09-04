//
//  PromptCell.swift
//  AskJoe
//
//  Created by Денис on 14.02.2023.
//

import UIKit

final class PromptCell: Cell<PromptCell.Model, TapOnlyAction> {

    static let reuseId = String(describing: PromptCell.self)

    // MARK: - Types

    struct Model {

        let style: Style
    }

    enum Style {
        case prompt(prompt: Prompt, title: String?)
        case chat(Chat)
    }

    // MARK: - Private Properties

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.white
        view.roundCorners(18)
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()

    private let promptTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(12)
        label.textColor = Assets.Colors.mediumGray
        return label
    }()

    private let characterTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .regular(14).boldItalic
        view.textColor = Assets.Colors.black
        return view
    }()

    private let messageLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = Assets.Colors.black
        view.font = .medium(14)
        return view
    }()

    private let arrowImageView: UIImageView = {
        let view = UIImageView(image: .init(named: "arrowRight"))
        view.tintColor = Assets.Colors.gray
        return view
    }()

    private let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = Assets.Colors.mediumGray
        view.font = .regular(12)
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()
        
        clipsToBounds = true
        selectionStyle = .none
        containerView.backgroundColor = Assets.Colors.white
        backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(arrowImageView)
        stackView.addArrangedSubview(promptTitleLabel)
        stackView.addArrangedSubview(characterTitleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(dateLabel)
    }

    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
        arrowImageView.snp.remakeConstraints { make in
            make.left.equalTo(stackView.snp.right).offset(8)
            make.top.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        super.setupConstraints()
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        switch model.style {
        case let .prompt(prompt, title):
            characterTitleLabel.isHidden = true
            promptTitleLabel.isHidden = title == nil
            promptTitleLabel.text = title
            messageLabel.text = prompt.text
            dateLabel.text = prompt.date?.formatPromptDate
            dateLabel.isHidden = prompt.date == nil
        case let .chat(chat):
            promptTitleLabel.isHidden = true
            characterTitleLabel.isHidden = chat.person == nil
            characterTitleLabel.text = chat.person?.name
            let message = chat.messages.first
            messageLabel.text = message?.text ?? ""
            dateLabel.text = message?.date.formatPromptDate
            dateLabel.isHidden = false
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
