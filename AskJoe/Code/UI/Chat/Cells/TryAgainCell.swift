//
//  TryAgainCell.swift
//  AskJoe
//
//  Created by Денис on 13.04.2023.
//

import UIKit

final class TryAgainCell: Cell<EmptyModel, TapOnlyAction> {

    static let reuseId = String(describing: TryAgainCell.self)

    // MARK: - Private Properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .medium(14)
        label.textColor = Assets.Colors.dark
        label.textAlignment = .center
        label.text = L10n.Chat.noAnswer
        return label
    }()

    private let tryAgainLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(14).boldItalic
        label.textColor = Assets.Colors.accentColor
        label.textAlignment = .center
        label.text = L10n.Chat.tryAgain
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(tryAgainLabel)
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        super.setupConstraints()
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
