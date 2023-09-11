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
        var style: Style = .loading
    }

    enum Action {
        case errorTap
        case originalTextTap
        case voiceTap
        case copyTap
        case favTap
    }

    enum Style: Hashable {
        case loading
        case error
        case right(language: Language, isPlaying: Bool)
        case left(language: Language, isPlaying: Bool)
    }

    // MARK: - Public Properties

    let translationBgContainer = UIView()

    // MARK: - Private Properties

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private let translationLabel: UILabel = {
        let view = UILabel()
        view.font = .medium(18)
        view.numberOfLines = 0
        return view
    }()

    private let buttons = MessageButtons()

    private let originalTextLabel: UILabel = {
        let view = UILabel()
        view.font = .regular(14)
        view.textColor = Assets.Colors.dark
        view.numberOfLines = 3
        view.isUserInteractionEnabled = true
        return view
    }()

    private let errorLabel: UILabel = {
        let view = UILabel()
        view.font = .medium(16).boldItalic
        view.textColor = UIColor(Assets.Colors.accentColor)
        view.isUserInteractionEnabled = true
        view.textAlignment = .center
        view.text = "Try again"
        return view
    }()

    private let activityIndicator = UIActivityIndicatorView()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        contentView.addSubview(stackView)
        stackView.addArrangedSubview(translationBgContainer)
        translationBgContainer.addSubview(translationLabel)
        stackView.addArrangedSubview(buttons)
        stackView.addArrangedSubview(originalTextLabel)
        stackView.addArrangedSubview(errorLabel)

        isUserInteractionEnabled = true

        backgroundColor = UIColor(Assets.Colors.white)
        selectionStyle = .none
        translationBgContainer.roundCorners(12)
    }

    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
        translationBgContainer.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
        buttons.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        translationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        super.setupConstraints()
    }

    override func bind() {
        let originalTextTap = UITapGestureRecognizer(target: self, action: #selector(onOriginalTextTap))
        originalTextLabel.addGestureRecognizer(originalTextTap)

        let errorTap = UITapGestureRecognizer(target: self, action: #selector(onErrorTextTap))
        errorLabel.addGestureRecognizer(errorTap)

        buttons.onAction = { [weak self] action in
            switch action {
            case .copyTap:
                self?.onAction?(.copyTap)
            case .favTap:
                self?.onAction?(.favTap)
            case .voiceTap:
                self?.onAction?(.voiceTap)
            }
        }
        super.bind()
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

        switch model.style {
        case .loading:
            stackView.alignment = .center

            buttons.isHidden = true
            translationBgContainer.isHidden = true
            errorLabel.isHidden = true
            stackView.addArrangedSubview(activityIndicator)
            activityIndicator.startAnimating()

            stackView.setCustomSpacing(8, after: originalTextLabel)

            originalTextLabel.textAlignment = .center
        case .error:
            stackView.alignment = .center

            buttons.isHidden = true
            translationBgContainer.isHidden = true
            errorLabel.isHidden = false

            stackView.setCustomSpacing(8, after: originalTextLabel)

            originalTextLabel.textAlignment = .center
        case let .right(language, isPlaying):
            stackView.alignment = .trailing

            buttons.isHidden = false
            translationBgContainer.isHidden = false
            errorLabel.isHidden = true
            activityIndicator.removeFromSuperview()
            activityIndicator.stopAnimating()

            stackView.setCustomSpacing(4, after: translationBgContainer)
            stackView.setCustomSpacing(8, after: buttons)

            translationLabel.textColor = language.color?.textColor
            translationBgContainer.backgroundColor = language.color?.bgColor

            buttons.model = .init(alignment: .right, isPlaying: isPlaying)
            originalTextLabel.textAlignment = .right
        case let .left(language, isPlaying):
            stackView.alignment = .leading

            buttons.isHidden = false
            translationBgContainer.isHidden = false
            errorLabel.isHidden = true
            activityIndicator.removeFromSuperview()
            activityIndicator.stopAnimating()
            
            stackView.setCustomSpacing(4, after: translationBgContainer)
            stackView.setCustomSpacing(8, after: buttons)

            translationLabel.textColor = language.color?.textColor
            translationBgContainer.backgroundColor = language.color?.bgColor

            buttons.model = .init(alignment: .left, isPlaying: isPlaying)
            originalTextLabel.textAlignment = .left
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onOriginalTextTap() {
        onAction?(.originalTextTap)
    }

    @objc
    private func onErrorTextTap() {
        onAction?(.errorTap)
    }
}
