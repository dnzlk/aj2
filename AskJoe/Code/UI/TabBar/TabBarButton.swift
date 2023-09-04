//
//  TabBarButton.swift
//  AskJoe
//
//  Created by Денис on 29.05.2023.
//

import UIKit

final class TabBarButton: View<TabBarButton.Model, TapOnlyAction> {

    // MARK: - Types

    struct Model {

        let tab: Tab
        var isSelected: Bool
    }

    enum Tab {
        case feed
        case scenarios

        var title: String {
            switch self {
            case .feed:
                return "Feed"
            case .scenarios:
                return "Scenarios"
            }
        }

        var selectedImage: UIImage? {
            switch self {
            case .feed:
                return .init(named: "TabBar/feedSelected")
            case .scenarios:
                return .init(named: "TabBar/scenariosSelected")
            }
        }

        var notSelectedImage: UIImage? {
            switch self {
            case .feed:
                return .init(named: "TabBar/feedNotSelected")
            case .scenarios:
                return .init(named: "TabBar/scenariosNotSelected")
            }
        }
    }

    // MARK: - Private Properties

    private let imageView = UIImageView()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .bold(10)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        addSubview(imageView)
        addSubview(label)
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }
        label.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        if model.isSelected {
            imageView.image = model.tab.selectedImage
            label.textColor = Assets.Colors.accentColor
        } else {
            imageView.image = model.tab.notSelectedImage
            label.textColor = Assets.Colors.mediumGray
        }
        label.text = model.tab.title

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
