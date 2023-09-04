//
//  HistoryController.swift
//  AskJoe
//
//  Created by Денис on 16.02.2023.
//

import UIKit

final class HistoryController: ViewController {

    // MARK: - Private Properties

    private let navBar = NavBar(model: .init(title: .plain(L10n.History.history),
                                             backgroundColor: Assets.Colors.solidWhite,
                                             backButtonImage: .init(named: "arrowBack"),
                                             rightButton: .init(systemName: "trash")))

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = Assets.Colors.solidWhite
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.estimatedRowHeight = 56
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 16, left: 0, bottom: 8, right: 0)
        return view
    }()

    private let dm = DataManager.shared
    private let nm = NotificationsManager.shared

    private var history: [Chat] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Assets.Colors.solidWhite
        addNavBar()
        addTableView()

        nm.addObserver(self)
        updateHistory()
    }

    override func bind() {
        navBar.onAction = { [weak self] action in
            switch action {
            case .backButtonTap:
                self?.navigationController?.popViewController(animated: true)
            case .rightButtonTap:
                self?.onDeleteTap()
            }
        }
    }

    // MARK: - Private Methods

    private func addNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }

    private func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        tableView.register(PromptCell.self, forCellReuseIdentifier: PromptCell.reuseId)
    }

    private func openChat(chat: Chat? = nil, prompt: Prompt? = nil) {
        let vc = ChatController(chat: chat, prompt: prompt)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func onDeleteTap() {
        let alert = UIAlertController(title: L10n.History.clear, message: L10n.History.undo, preferredStyle: .alert)
        alert.addAction(.init(title: L10n.History.yes, style: .default, handler: { [weak self] _ in
            guard let self else { return }

            Task { await self.dm.delete(self.history) }

            self.navigationController?.popViewController(animated: true)
            FBAnalytics.log(.history_delete_all_tap)
        }))
        alert.addAction(.init(title: L10n.History.no, style: .cancel))
        present(alert, animated: true)
    }

    private func updateHistory() {
        Task {
            history = await dm.getChats()
            await MainActor.run {
                tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension HistoryController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        24
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PromptCell.reuseId, for: indexPath) as? PromptCell else {
            return UITableViewCell()
        }
        let chat = history[indexPath.row]
        cell.model = .init(style: .chat(chat))
        cell.onAction = { [weak self] action in
            switch action {
            case .tap:
                self?.openChat(chat: chat)
            }
        }

        return cell
    }
}

// MARK: - NotificationsObserver

extension HistoryController: NotificationsObserver {

    func onEvent(_ event: NotificationsManager.Event) {
        switch event {
        case .chatUpdated, .chatsRemoved:
            updateHistory()
        default:
            break
        }
    }
}

