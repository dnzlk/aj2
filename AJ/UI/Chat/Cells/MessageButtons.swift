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

        backgroundColor = Assets.Colors.gray

        roundCorners(4)

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

        switch model.alignment {
        case .left:
            voiceButton.snp.remakeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.height.equalTo(25)
            }
            copyButton.snp.remakeConstraints { make in
                make.left.equalTo(voiceButton.snp.right).inset(2)
                make.top.bottom.equalToSuperview()
                make.height.equalTo(25)
            }
            favButton.snp.remakeConstraints { make in
                make.left.equalTo(copyButton.snp.right).inset(2)
                make.top.bottom.right.equalToSuperview()
                make.height.equalTo(25)
            }
        case .right:
            favButton.snp.remakeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.height.equalTo(25)
            }
            copyButton.snp.remakeConstraints { make in
                make.left.equalTo(favButton.snp.right).inset(2)
                make.top.bottom.equalToSuperview()
                make.height.equalTo(25)
            }
            voiceButton.snp.remakeConstraints { make in
                make.left.equalTo(copyButton.snp.right).inset(2)
                make.top.bottom.right.equalToSuperview()
                make.height.equalTo(25)
            }
        }
        super.reloadData(animated: animated)
    }
}

private extension MessageButtons {
    
    final class Button: _View<Button.Model, TapOnlyAction> {

        // MARK: - Types

        struct Model {

            let image: UIImage?
        }

        // MARK: - Private Properties

        private let imageView = UIImageView()

        // MARK: - Lifecycle

        override func make() {
            super.make()

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

            super.reloadData(animated: animated)
        }

        // MARK: - Private Methods

        @objc
        private func onTap() {
            onAction?(.tap)
        }
    }
}
