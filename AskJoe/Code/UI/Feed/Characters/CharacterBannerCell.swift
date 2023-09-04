//
//  CharacterBannerCell.swift
//  AskJoe
//
//  Created by Денис on 30.03.2023.
//

import UIKit
import Nuke

final class CharacterBannerCell: Cell<CharacterBannerCell.Model, TapOnlyAction> {

    static let reuseId = String(describing: CharacterBannerCell.self)

    // MARK: - Types

    struct Model {

        let snippet: FeedItem.CharacterSnippet
    }

    // MARK: - Private Properties

    private let container = UIView()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let gradientView = UIView()
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.45).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradient
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(18)
        label.textColor = .white
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()

    private let button: UIView = {
        let view = UIView()
        view.roundCorners(12)
        view.backgroundColor = Assets.Colors.accentColor
        return view
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(12)
        label.textColor = Assets.Colors.textOnAccent
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        selectionStyle = .none
        backgroundColor = .clear
        container.roundCorners(18)
        container.clipsToBounds = true

        contentView.addSubview(container)
        container.addSubview(posterImageView)
        container.addSubview(gradientView)
        container.addSubview(titleLabel)
        container.addSubview(button)
        button.addSubview(buttonLabel)

        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = gradientView.bounds
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        posterImageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(136)
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(8)
        }
        button.snp.remakeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.right.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        buttonLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(2)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        titleLabel.text = model.snippet.title

        if let avatarUrl = model.snippet.image, let url = URL(string: avatarUrl) {
            Task { posterImageView.image = try? await ImagePipeline.shared.image(for: url)}
        }
        buttonLabel.text = model.snippet.buttonText
        button.isHidden = model.snippet.buttonText == nil

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}

extension CharacterBannerCell: Skeletonable {

    final class Skeleton: View<EmptyModel, EmptyAction>, SkeletonableView {

        // MARK: - Public Properties

        var shimmeringViews: [ShimmeringView] {
            [banner]
        }

        // MARK: - Private Properties

        private let banner = ShimmeringView(model: .init(cornerRadius: 12))

        // MARK: - Lifecycle

        override func make() {
            super.make()

            backgroundColor = .clear
            addSubview(banner)
        }

        override func setupConstraints() {
            banner.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(8)
                make.top.bottom.equalToSuperview()
                make.height.equalTo(136)
            }
            super.setupConstraints()
        }
    }
}
