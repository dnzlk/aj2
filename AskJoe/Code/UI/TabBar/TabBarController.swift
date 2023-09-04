//
//  TabBarController.swift
//  AskJoe
//
//  Created by Денис on 29.05.2023.
//

import UIKit

final class TabBarController: ViewController {

    // MARK: - Private Properties

    private let navBar = FeedNavBar()

    private let feedController = FeedController()
    private let scenariosController = ScenariosController()
    private let tabBar = TabBar(model: .init())

    private let bottomBlurContainer = UIView()

    private let blurView: UIView = {
        let style: UIBlurEffect.Style = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .regular : .extraLight
        let blurEffect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Assets.Colors.solidWhite

        addNavBar()
        addControllers()
        addBottomBlurAndTabBar()
    }

    override func bind() {
        tabBar.onAction = { [weak self] action in
            switch action {
            case .feedTap:
                if self?.tabBar.model?.currentTab == .feed {
                    self?.feedController.scrollToTop()
                } else {
                    self?.tabBar.model?.currentTab = .feed
                    self?.updateSelectedController()
                }
            case .startChatTap:
                let vc = ChatController()
                self?.navigationController?.pushViewController(vc, animated: true)
            case .scenariosTap:
                self?.tabBar.model?.currentTab = .scenarios
                self?.updateSelectedController()
            }
        }
        navBar.onAction = { [weak self] action in
            switch action {
            case .historyTap:
                self?.openHistory()
                FBAnalytics.log(.main_see_all_history_tap)
            case .settingsTap:
                self?.openSettings()
                FBAnalytics.log(.main_settings_tap)
            }
        }
        super.bind()
    }

    // MARK: - Private Methods

    private func addNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func addControllers() {
        addChild(feedController)
        view.addSubview(feedController.view)
        feedController.view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        addChild(scenariosController)
        view.addSubview(scenariosController.view)
        scenariosController.view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        scenariosController.view.isHidden = true
    }

    private func addBottomBlurAndTabBar() {
        view.addSubview(bottomBlurContainer)
        bottomBlurContainer.addSubview(blurView)
        view.addSubview(tabBar)
        bottomBlurContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tabBar.snp.top).offset(8)
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tabBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(68)
        }
    }

    private func openSettings() {
        let vc = SettingsController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openHistory() {
        let controller = HistoryController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func updateSelectedController() {
        guard let tab = tabBar.model?.currentTab else { return }

        feedController.view.isHidden = tab != .feed
        scenariosController.view.isHidden = tab != .scenarios
    }
}
