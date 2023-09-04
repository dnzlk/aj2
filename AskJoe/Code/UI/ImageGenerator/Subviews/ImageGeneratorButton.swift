//
//  ImageGeneratorButton.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import UIKit

final class ImageGeneratorButton: View<ImageGeneratorButton.Model, TapOnlyAction> {

    // MARK: - Types

    struct Model {

        let icon: UIImage?
        let title: String
    }

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.roundCorners(18)
        view.layer.borderColor = Assets.Colors.black?.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        return view
    }()

    private let iconLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        return stackView
    }()
    private let icon = UIImageView()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .medium(15)
        label.textColor = Assets.Colors.black
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        addSubview(container)
        container.addSubview(iconLabelStackView)
        iconLabelStackView.addArrangedSubview(icon)
        iconLabelStackView.addArrangedSubview(label)
    }

    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconLabelStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        super.setupConstraints()
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        icon.image = model.icon
        label.text = model.title

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
