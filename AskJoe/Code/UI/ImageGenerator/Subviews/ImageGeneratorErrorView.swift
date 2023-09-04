//
//  ImageGeneratorErrorView.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import UIKit

final class ImageGeneratorErrorView: View<String, TapOnlyAction> {

    // MARK: - Private Properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .regular(16)
        label.textColor = Assets.Colors.black
        label.text = L10n.Images.somethingWentWrong
        label.textAlignment = .center
        return label
    }()

    private let tryAgain: UILabel = {
        let label = UILabel()
        label.font = .medium(14)
        label.textColor = Assets.Colors.accentColor
        label.textAlignment = .center
        label.text = L10n.Images.tryAgain
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(tryAgain)
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

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        label.text = model

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}

