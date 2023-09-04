//
//  ImageGeneratorLoadedView.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import UIKit

final class ImageGeneratorLoadedView: View<ImageGeneratorLoadedView.Model, ImageGeneratorLoadedView.Action> {

    // MARK: - Types

    struct Model {

        let request: String
        let onLoadedImage: ((UIImage?) -> Void)
    }

    enum Action {
        case share
        case save
    }

    // MARK: - Private Properties

    private let image = ImageView()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        addSubview(image)
        addSubview(buttonsStackView)

        let saveButton = ImageGeneratorButton(model: .init(icon: nil, title: L10n.Images.save))
        saveButton.onAction = { [weak self] action in
            switch action {
            case .tap:
                self?.onAction?(.save)
            }
        }
        let shareButton = ImageGeneratorButton(model: .init(icon: nil, title: L10n.Images.share))
        shareButton.onAction = { [weak self] action in
            switch action {
            case .tap:
                self?.onAction?(.share)
            }
        }
        buttonsStackView.addArrangedSubview(saveButton)
        buttonsStackView.addArrangedSubview(shareButton)
    }

    override func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(image.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        image.model = .init(urlString: model.request, onImageLoaded: model.onLoadedImage)

        super.reloadData(animated: animated)
    }
}

