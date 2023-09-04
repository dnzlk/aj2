//
//  HomeNavBar.swift
//  AskJoe
//
//  Created by Денис on 14.02.2023.
//

import UIKit

final class FeedNavBar: View<FeedNavBar.Model, FeedNavBar.Action> {

    // MARK: - Types

    struct Model {

        var hasNotifications: Bool
    }

    enum Action {
        case historyTap
        case settingsTap
    }

    // MARK: - Private Properties

    private let container = UIView()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = .init(named: "logo")
        return view
    }()

    private let historyButton: UIButton = {
        let view = UIButton()
        view.setImage(.init(named: "history"), for: .normal)
        return view
    }()

    private let settingsButton: UIButton = {
        let view = UIButton()
        view.setImage(.init(named: "settings"), for: .normal)
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        addSubview(container)
        container.addSubview(imageView)
        container.addSubview(historyButton)
        container.addSubview(settingsButton)

        container.backgroundColor = Assets.Colors.solidWhite
    }

    override func setupConstraints() {
        container.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        historyButton.snp.remakeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        settingsButton.snp.remakeConstraints { make in
            make.left.equalTo(historyButton.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
            make.centerY.equalTo(imageView.snp.centerY)
        }
    }

    override func bind() {
        historyButton.addTarget(self, action: #selector(onHistoryTap), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(onSettingsTap), for: .touchUpInside)
    }

    // MARK: - Private Methods

    @objc
    private func onHistoryTap() {
        onAction?(.historyTap)
    }

    @objc
    private func onSettingsTap() {
        onAction?(.settingsTap)
    }
}
