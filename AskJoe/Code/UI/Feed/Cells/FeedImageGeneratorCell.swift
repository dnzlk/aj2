//
//  FeedImageGeneratorCell.swift
//  AskJoe
//
//  Created by Денис on 26.04.2023.
//

import UIKit
import Nuke

final class FeedImageGeneratorCell: Cell<FeedImageGeneratorCell.Model, FeedImageGeneratorCell.Action> {

    static let reuseId = String(describing: FeedImageGeneratorCell.self)

    // MARK: - Types

    struct Model {

        let title: String
        let url: String
    }

    enum Action {
        case tap
        case imageLoaded
    }

    // MARK: - Private Properties

    private let container: UIView = {
        let view = UIView()
        view.roundCorners(18)
        view.clipsToBounds = true
        return view
    }()

    private let bgImageView = ImageView()

    private let descriptionContainer: UIView = {
        let view = UIView()
        view.roundCorners(12)
        view.backgroundColor = .black.withAlphaComponent(0.65)
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(12)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        selectionStyle = .none
        backgroundColor = .clear

        addSubview(container)
        container.addSubview(bgImageView)
        container.addSubview(descriptionContainer)
        descriptionContainer.addSubview(descriptionLabel)
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))

        addGestureRecognizer(tap)
        super.bind()
    }

    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        bgImageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(200)
        }
        descriptionContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(8)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        bgImageView.model = .init(urlString: model.url, radius: 18, onImageLoaded: { [weak self] _ in
            self?.onAction?(.imageLoaded)
        })
        descriptionLabel.text = model.title
        
        super.reloadData(animated: false)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
