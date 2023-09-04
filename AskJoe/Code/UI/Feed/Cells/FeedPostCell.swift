//
//  FeedPostCell.swift
//  AskJoe
//
//  Created by Денис on 23.03.2023.
//

import UIKit
import Nuke

final class FeedPostCell: Cell<FeedItem, FeedPostCell.Action> {

    static let reuseId = String(describing: FeedPostCell.self)

    // MARK: - Types

    enum Action {
        case tap
        case imageLoaded
    }

    // MARK: - Private Properties

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.white
        view.roundCorners(18)
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()

    private let postImageView = ImageView()

    private let textsAndArrowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .top
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()

    private let textsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(16)
        label.numberOfLines = 2
        label.textColor = Assets.Colors.black
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(14)
        label.numberOfLines = 0
        label.textColor = Assets.Colors.black
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let arrowImage: UIImageView = {
        let image = UIImageView(image: .init(named: "postArrow"))
        return image
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(container)
        container.addSubview(stackView)
        stackView.addArrangedSubview(postImageView)
        stackView.addArrangedSubview(textsAndArrowStackView)
        textsAndArrowStackView.addArrangedSubview(textsStackView)
        textsAndArrowStackView.addArrangedSubview(arrowImage)
        textsStackView.addArrangedSubview(titleLabel)
        textsStackView.addArrangedSubview(descriptionLabel)
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
        arrowImage.snp.remakeConstraints { make in
            make.size.equalTo(24)
        }
        postImageView.snp.remakeConstraints { make in
            make.width.equalTo(stackView.snp.width)
        }
        textsAndArrowStackView.snp.remakeConstraints { make in
            make.width.equalTo(stackView.snp.width)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        switch model.type {
        case let .post(snippet, _), let .externalPost(snippet, _):
            stackView.isHidden = false

            if let image = snippet.image {
                postImageView.isHidden = false
                postImageView.model = .init(urlString: image, radius: 0, onImageLoaded: { [weak self] _ in
                    self?.onAction?(.imageLoaded)
                })
                stackView.snp.remakeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview().inset(8)
                }
                textsAndArrowStackView.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview().inset(12)
                }
            } else {
                postImageView.isHidden = true
                stackView.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview().inset(12)
                    make.top.bottom.equalToSuperview().inset(8)
                }
                textsAndArrowStackView.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                }
            }
            titleLabel.text = snippet.title
            descriptionLabel.text = snippet.description
            descriptionLabel.isHidden = snippet.description == nil
        default:
            stackView.isHidden = true
            break
        }
        super.reloadData(animated: false)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}

extension FeedPostCell: Skeletonable {

    final class Skeleton: View<EmptyModel, EmptyAction>, SkeletonableView {

        // MARK: - Public Properties

        var shimmeringViews: [ShimmeringView] {
            [view]
        }

        // MARK: - Private Properties

        private let view = ShimmeringView(model: .init(cornerRadius: 12))

        // MARK: - Lifecycle

        override func make() {
            super.make()

            backgroundColor = .clear
            addSubview(view)
        }

        override func setupConstraints() {
            view.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(8)
                make.top.bottom.equalToSuperview()
                make.height.equalTo(240)
            }
            super.setupConstraints()
        }
    }

}
