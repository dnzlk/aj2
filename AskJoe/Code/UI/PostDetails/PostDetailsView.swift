//
//  PostDetailsView.swift
//  AskJoe
//
//  Created by Денис on 30.03.2023.
//

import UIKit
import Nuke

final class PostDetailsView: View<Post, PostDetailsView.Action> {

    // MARK: - Types

    enum Action {
        case backButtonPressed
    }

    // MARK: - Private Properties

    private let navBar = NavBar(model: .init(backgroundColor: Assets.Colors.solidWhite,
                                             backButtonImage: .init(named: "arrowBack")))

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = Assets.Colors.solidWhite

        addSubview(navBar)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }

    override func bind() {
        navBar.onAction = { [weak self] action in
            switch action {
            case .backButtonTap:
                self?.onAction?(.backButtonPressed)
            case .rightButtonTap:
                break
            }
        }
        super.bind()
    }

    override func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(navBar.snp.bottom)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let post = model else {
            super.reloadData(animated: animated)
            return
        }
        let title = generateTitleView(string: post.title)
        let date = generateDateView(date: post.createdAt)
        let blocks = post.blocks.map { generateBlockItem(block: $0) }

        stackView.addArrangedSubviews([title, date] + blocks)
        stackView.setCustomSpacing(8, after: title)

        super.reloadData(animated: true)
    }

    // MARK: - Private Methods

    private func generateTitleView(string: String) -> UIView {
        let label = UILabel()
        label.font = .bold(24)
        label.text = string
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = Assets.Colors.solidBlack

        return label
    }

    private func generateDateView(date: Date?) -> UIView {
        let label = UILabel()
        label.font = .regular(12)
        label.text = "\(L10n.Post.postedOn) \(date?.formatPostDate ?? "")"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = Assets.Colors.mediumGray

        return label
    }

    func generateBlockItem(block: FeedItem.Block) -> UIView {
        switch block {
        case let .text(text):
            let label = UILabel()
            label.font = .regular(14)
            label.text = text
            label.textAlignment = .left
            label.numberOfLines = 0
            label.textColor = Assets.Colors.black

            return label

        case let .subtitle(text):
            let label = UILabel()
            label.font = .bold(18)
            label.text = text
            label.textAlignment = .left
            label.numberOfLines = 0
            label.textColor = Assets.Colors.black

            return label
        case let .image(url):
            let imageView = ImageView(model: .init(urlString: url.absoluteString))

            return imageView
        }
    }
}
