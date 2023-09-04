//
//  NavBar.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import UIKit
import Nuke

final class NavBar: View<NavBar.Model, NavBar.Action> {

    // MARK: - Types

    struct Model {

        var title: Title? = nil
        var avatarURL: String? = nil
        var backgroundColor: UIColor? = .clear
        var backButtonImage: UIImage?
        var rightButton: UIImage? = nil
    }

    enum Title {
        case plain(String)
        case attributed(NSAttributedString)
    }

    enum Action {
        case backButtonTap
        case rightButtonTap
    }

    // MARK: - Private Properties

    private let container = UIView()

    private let label: UILabel = {
        let view = UILabel()
        view.textColor = Assets.Colors.solidBlack
        return view
    }()

    private let backButton = UIButton()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.roundCorners(12)
        return imageView
    }()

    private let rightButton = UIButton()

    // MARK: - Lifecycle

    override func make() {
        addSubview(container)
        container.addSubview(label)
        container.addSubview(backButton)
        container.addSubview(rightButton)
        container.addSubview(avatarImageView)
    }

    override func setupConstraints() {
        container.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        label.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
        backButton.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.width.equalTo(32)
            make.height.equalTo(24)
            make.centerY.equalTo(label.snp.centerY)
        }
        rightButton.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
            make.centerY.equalTo(label.snp.centerY)
        }
        avatarImageView.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
            make.centerY.equalTo(label.snp.centerY)
        }
    }

    override func bind() {
        backButton.addTarget(self, action: #selector(onSettingsTap), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(onRightButtonTap), for: .touchUpInside)
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        if let title = model.title {
            switch title {
            case let .plain(text):
                label.text = text
                label.font = .bold(18)
            case let .attributed(string):
                label.attributedText = string
            }
        }
        container.backgroundColor = backgroundColor
        backButton.setImage(model.backButtonImage, for: .normal)

        rightButton.setImage(model.rightButton, for: .normal)
        rightButton.isHidden = model.rightButton == nil
        rightButton.tintColor = .red

        if let avatarURL = model.avatarURL, let url = URL(string: avatarURL) {
            Task {
                avatarImageView.image = try await ImagePipeline.shared.image(for: url)
            }
        }
        avatarImageView.isHidden = model.avatarURL == nil

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onSettingsTap() {
        onAction?(.backButtonTap)
    }

    @objc
    private func onRightButtonTap() {
        onAction?(.rightButtonTap)
    }
}
