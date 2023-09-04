//
//  ChatPersonPromptsView.swift
//  AskJoe
//
//  Created by Денис on 19.03.2023.
//

import UIKit

final class ChatPersonPromptsView: View<Person, ChatPersonPromptsView.Action> {

    // MARK: - Types

    enum Action {
        case tap(String)
    }

    // MARK: - Private Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(14)
        label.textColor = Assets.Colors.dark
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        roundCorners(18)
        clipsToBounds = true
        backgroundColor = Assets.Colors.solidWhite

        addSubview(titleLabel)
        addSubview(stackView)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(24)
        }
        stackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        titleLabel.text = L10n.Chat.aFewExamples(model.name)

        stackView.removeAllArrangedSubviews()

        for prompt in model.prompts {
            let view = createPromptView(prompt)
            stackView.addArrangedSubview(view)
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    private func createPromptView(_ prompt: String) -> UIView {
        let accent = Assets.Colors.accentColor

        let view = UIView()
        view.layer.borderColor = accent?.cgColor
        view.layer.borderWidth = 1
        view.roundCorners(12)
        view.backgroundColor = Assets.Colors.solidWhite

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .regular(14)
        label.textColor = accent
        label.textAlignment = .center
        label.text = prompt
        label.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapLabel(sender:)))
        label.addGestureRecognizer(tap)

        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.bottom.equalToSuperview().inset(8)
        }
        return view
    }

    @objc
    private func onTapLabel(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let text = label.text else { return }

        onAction?(.tap(text))
    }
}
