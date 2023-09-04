//
//  FreeTrialCell.swift
//  AskJoe
//
//  Created by Денис on 02.04.2023.
//

import UIKit

final class FreeTrialCell: Cell<FreeTrialCell.Model, TapOnlyAction> {

    static let reuseId = String(describing: FreeTrialCell.self)

    // MARK: - Types

    struct Model {

        let messages: Int
        let images: Int
    }

    // MARK: - Private Properties

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.white
        view.roundCorners(18)
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()

    private let countLabel: UILabel = {
        let view = UILabel()
        view.font = .medium(14)
        view.textColor = Assets.Colors.dark
        view.numberOfLines = 0
        return view
    }()

    private let startLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = Assets.Colors.black
        view.text = L10n.Feed.startFreeTrial
        view.font = .bold(18)
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(startLabel)
    }

    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        super.setupConstraints()
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func reloadData(animated: Bool) {
        guard let model, let blackColor = Assets.Colors.black?.cgColor else {
            super.reloadData(animated: animated)
            return
        }
        let string = L10n.Feed.youHaveMessagesLeft(model.messages, model.images)
        let attributedString = NSMutableAttributedString(string: string)
        let attrs = [NSAttributedString.Key.font : UIFont.bold(14).boldItalic,
                     NSAttributedString.Key.foregroundColor: blackColor] as [NSAttributedString.Key : Any]
        let messagesRange = (string as NSString).range(of: L10n.Feed.messagesLeft(model.messages))
        let imagesRange = (string as NSString).range(of: L10n.Feed.imagesLeft(model.images))
        attributedString.addAttributes(attrs, range: messagesRange)
        attributedString.addAttributes(attrs, range: imagesRange)
        countLabel.attributedText = attributedString
        countLabel.isHidden = model.messages <= 0 && model.images <= 0

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
