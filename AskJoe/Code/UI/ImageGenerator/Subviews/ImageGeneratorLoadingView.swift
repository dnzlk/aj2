//
//  ImageGeneratorLoadingView.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import UIKit

final class ImageGeneratorLoadingView: View<EmptyModel, EmptyAction> {

    // MARK: - Private Properties

    private let container = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let label: UILabel = {
        let label = UILabel()
        label.font = .regular(16)
        label.textColor = Assets.Colors.mediumGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = L10n.Images.itMayTakeTime
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        addSubview(container)
        container.addSubview(activityIndicator)
        container.addSubview(label)
    }

    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(activityIndicator.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        super.setupConstraints()
    }

    // MARK: - Public Methods

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
