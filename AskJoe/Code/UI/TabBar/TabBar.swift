//
//  TabBar.swift
//  AskJoe
//
//  Created by Денис on 29.05.2023.
//

import UIKit

final class TabBar: View<TabBar.Model, TabBar.Action> {

    // MARK: - Types

    struct Model {

        var currentTab: TabBarButton.Tab = .feed
    }

    enum Action {
        case feedTap
        case startChatTap
        case scenariosTap
    }

    // MARK: - Private Properties

    private let feedButton = TabBarButton(model: .init(tab: .feed, isSelected: true))
    private let startButton = TabBarStartButton()
    private let scenariosButton = TabBarButton(model: .init(tab: .scenarios, isSelected: false))

    // MARK: - Lifecycle

    override func make() {
        super.make()

        addSubview(startButton)
        addSubview(feedButton)
        addSubview(scenariosButton)
    }

    override func bind() {
        feedButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.feedTap)
        }
        scenariosButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.scenariosTap)
        }
        startButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.startChatTap)
        }
        super.bind()
    }

    override func setupConstraints() {
        startButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
        }
        feedButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(startButton.snp.left)
            make.top.equalToSuperview().offset(24)
        }
        scenariosButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(startButton.snp.right)
            make.top.equalToSuperview().offset(24)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        feedButton.model?.isSelected = model.currentTab == .feed
        scenariosButton.model?.isSelected = model.currentTab == .scenarios

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onFeedTap() {
        onAction?(.feedTap)
    }

    @objc
    private func onScenariosTap() {
        onAction?(.scenariosTap)
    }
}
