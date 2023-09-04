//
//  ImageGeneratorPlaceholder.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import UIKit

final class ImageGeneratorPlaceholder: View<String, TapOnlyAction> {

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
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let doItLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(14)
        label.textColor = Assets.Colors.accentColor
        label.textAlignment = .center
        label.text = L10n.Images.doItForMe
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(doItLabel)
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
