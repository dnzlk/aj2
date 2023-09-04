//
//  SettingsCell.swift
//  AskJoe
//
//  Created by Денис on 16.02.2023.
//

import UIKit

final class SettingsCell: Cell<SettingsCell.Model, EmptyAction> {

    static let reuseId = String(describing: SettingsCell.self)

    // MARK: - Types

    struct Model {

        var icon: UIImage?
        var text: String
    }

    // MARK: - Private Properties

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.solidWhite
        view.roundCorners(18)
        return view
    }()

    private let iconView = UIImageView()

    private let label: UILabel = {
        let view = UILabel()
        view.font = .medium(16)
        view.textColor = Assets.Colors.black
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(label)
    }

    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        iconView.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        iconView.image = model.icon
        label.text = model.text

        super.reloadData(animated: animated)
    }
}
