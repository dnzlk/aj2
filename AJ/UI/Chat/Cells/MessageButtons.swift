//
//  MessageButtons.swift
//  AJ
//
//  Created by Денис on 08.09.2023.
//

import UIKit

final class MessageButtons: _View<MessageButtons.Model, MessageButtons.Action> {

    // MARK: - Types

    struct Model {

        let alignment: Alignment
        var isPlaying = false
        var isFav = false
    }

    enum Action {
        case favTap
        case voiceTap
        case copyTap
    }

    enum Alignment {
        case left
        case right
    }

    // MARK: - Private Properties

    private let copyButton = Button(model: .init(image: .init(systemName: "doc.on.doc")))
    private let favButton = Button()
    private let voiceButton = Button(model: .init(image: .init(systemName: "speaker.wave.2")))

    // MARK: - Lifecycle

    override func make() {
        super.make()

        isUserInteractionEnabled = true
        
        backgroundColor = Assets.Colors.gray

        roundCorners(8)

        addSubview(favButton)
        addSubview(copyButton)
        addSubview(voiceButton)
    }

    override func bind() {
        copyButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.copyTap)
        }
        favButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.favTap)
        }
        voiceButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.voiceTap)
        }
        super.bind()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            return
        }
        favButton.model = .init(image: .init(systemName: model.isFav ? "star.fill" : "star"))
        let buttonWidth: CGFloat = 60

        switch model.alignment {
        case .left:
            voiceButton.snp.remakeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(buttonWidth)
            }
            copyButton.snp.remakeConstraints { make in
                make.left.equalTo(voiceButton.snp.right).offset(2)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(buttonWidth)
            }
            favButton.snp.remakeConstraints { make in
                make.left.equalTo(copyButton.snp.right).offset(2)
                make.top.bottom.right.equalToSuperview()
                make.width.equalTo(buttonWidth)
            }
        case .right:
            favButton.snp.remakeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(buttonWidth)
            }
            copyButton.snp.remakeConstraints { make in
                make.left.equalTo(favButton.snp.right).offset(2)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(buttonWidth)
            }
            voiceButton.snp.remakeConstraints { make in
                make.left.equalTo(copyButton.snp.right).offset(2)
                make.top.bottom.right.equalToSuperview()
                make.width.equalTo(buttonWidth)
            }
        }
        voiceButton.model?.color = model.isPlaying ? UIColor(Assets.Colors.accentColor) : .black

        super.reloadData(animated: animated)
    }
}

private extension MessageButtons {
    
    final class Button: _View<Button.Model, TapOnlyAction> {

        // MARK: - Types

        struct Model {

            let image: UIImage?
            var color: UIColor?
        }

        // MARK: - Private Properties

        private let imageView = UIImageView()

        // MARK: - Lifecycle

        override func make() {
            super.make()

            isUserInteractionEnabled = true

            backgroundColor = Assets.Colors.lightGray
            addSubview(imageView)
        }

        override func setupConstraints() {
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            super.setupConstraints()
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
            imageView.image = model.image
            imageView.tintColor = model.color ?? .black

            super.reloadData(animated: animated)
        }

        // MARK: - Private Methods

        @objc
        private func onTap() {
            onAction?(.tap)
        }
    }
}
