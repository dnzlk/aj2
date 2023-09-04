//
//  TabBarStartButton.swift
//  AskJoe
//
//  Created by Денис on 29.05.2023.
//

import UIKit

final class TabBarStartButton: View<EmptyModel, TapOnlyAction> {

    // MARK: - Private Properties

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.textOnAccent
        label.text = "Start chat!"
        label.font = .medium(16)
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = Assets.Colors.accentColor
        roundCorners(28)

        addSubview(label)

        layer.shadowRadius = 8
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor

        setContentHuggingPriority(.required, for: .horizontal)
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func setupConstraints() {
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(16)
        }
        super.setupConstraints()
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
