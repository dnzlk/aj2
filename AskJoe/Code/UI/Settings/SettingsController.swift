//
//  SettingsController.swift
//  AskJoe
//
//  Created by Денис on 16.02.2023.
//

import MessageUI
import UIKit

final class SettingsController: ViewController {

    // MARK: - Types

    private enum Section {
        case terms
        case contactUs

        var icon: UIImage? {
            switch self {
            case .terms:
                return .init(named: "terms")
            case .contactUs:
                return .init(named: "contactUs")
            }
        }

        var text: String {
            switch self {
            case .terms:
                return L10n.Settings.terms
            case .contactUs:
                return L10n.Settings.contactUs
            }
        }
    }

    // MARK: - Private Properties

    private let navBar = NavBar(model: .init(title: .plain(L10n.Settings.settings),
                                             backgroundColor: Assets.Colors.white,
                                             backButtonImage: .init(named: "arrowBack")))

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = Assets.Colors.white
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

    private let bottomContainer = UIView()

    private let bottomLogo = UIImageView(image: .init(named: "logo"))

    private let versionLabel: UILabel = {
        let view = UILabel()
        view.textColor = Assets.Colors.mediumGray
        view.font = .regular(12)
        view.textAlignment = .center
        return view
    }()

    private let bottomLabel: UILabel = {
        let view = UILabel()
        view.textColor = Assets.Colors.mediumGray
        view.font = .regular(12)
        view.numberOfLines = 2
        view.textAlignment = .center
        view.text = L10n.Settings.madeBy
        return view
    }()

    private let ud = UserDefaultsManager.shared

    private var sections: [Section] {
        [.terms, .contactUs]
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Assets.Colors.white
        bottomContainer.backgroundColor = Assets.Colors.white
        addNavBar()
        addTableView()
        addBottomInfo()
    }

    override func bind() {
        navBar.onAction = { [weak self] action in
            switch action {
            case .backButtonTap:
                self?.navigationController?.popViewController(animated: true)
            case .rightButtonTap:
                break
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentDebugAlert))
        tap.numberOfTapsRequired = 10
        bottomContainer.addGestureRecognizer(tap)
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
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(navBar.snp.bottom)
        }
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
    }

    private func addBottomInfo() {
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomLogo)
        bottomContainer.addSubview(versionLabel)
        bottomContainer.addSubview(bottomLabel)

        bottomContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(tableView.snp.bottom).offset(4)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        bottomLogo.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLogo.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = "\(L10n.Settings.ver). \(appVersion ?? "")"
    }

    private func openTerms() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(.init(title: L10n.Settings.terms, style: .default) { [weak self] _ in
            self?.openUrl(string: "https://www.getaskjoe.com/terms")
        })
        alert.addAction(.init(title: L10n.Settings.privacy, style: .default) { [weak self] _ in
            self?.openUrl(string: "https://www.getaskjoe.com/privacy")
        })
        alert.addAction(.init(title: L10n.Settings.cancel, style: .cancel))
        present(alert, animated: true)
    }

    private func openUrl(string: String) {
        if let url = URL(string: string) {
            openBrowser(url: url)
        }
    }

    private func presentContactUsEmailSending() {
        guard MFMailComposeViewController.canSendMail() else {
            showYouCantSendEmailAlert()
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        composeVC.setToRecipients(["support@getaskjoe.com"])
        composeVC.setSubject("AskJoe support")

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        composeVC.setMessageBody("\n\nver. \(appVersion ?? "")\n\(UIDevice().model) \(UIDevice().systemVersion)", isHTML: false)

        present(composeVC, animated: true)
    }

    private func showYouCantSendEmailAlert() {
        let email = "support@getaskjoe.com"
        let alert = UIAlertController(title: "Your device cannot send mail", message: "Contact us at \(email)", preferredStyle: .alert)
        alert.addAction(.init(title: "Copy email", style: .default, handler: { _ in
            UIPasteboard.general.string = email
        }))
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }

    @objc
    func presentDebugAlert() {
        guard !ud.isDebugMode() else {
            ud.setDebugMode(isOn: false)
            showYouSwitchedAlert(mode: "release")
            return
        }
        let alert = UIAlertController(title: "Switch to debug mode?", message: "Enter password", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(.init(title: "Enter", style: .default, handler: { [weak self] _ in
            guard let textField = alert.textFields?.first, let pass = textField.text else { return }

            guard SecurityManager.shared.checkDebugModePassword(string: pass) else { return }

            self?.ud.setDebugMode(isOn: true)
            self?.showYouSwitchedAlert(mode: "debug")
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showYouSwitchedAlert(mode: String) {
        let alert = UIAlertController(title: "You've switched to \(mode) mode", message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        let section = sections[indexPath.row]
        let text = section.text

        cell.model = .init(icon: section.icon, text: text)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.row]

        switch section {
        case .terms:
            openTerms()
        case .contactUs:
            presentContactUsEmailSending()
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
