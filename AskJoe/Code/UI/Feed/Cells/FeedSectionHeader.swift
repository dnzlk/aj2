//
//  FeedSectionHeader.swift
//  AskJoe
//
//  Created by Денис on 14.02.2023.
//

import UIKit
import SnapKit

final class FeedSectionHeader: Header<FeedSectionHeader.Model, FeedSectionHeader.Action> {

    // MARK: - Types

    struct Model {

        let text: String? = nil
        var buttonText: String? = nil
        var bigLabelText: String? = nil
    }

    enum Action {
        case buttonTap
    }

    // MARK: - Public Properties

    static let reuseId = String(describing: FeedSectionHeader.self)

    // MARK: - Private Properties

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()

    private let topContainer = UIView()

    private let label: UILabel = {
        let view = UILabel()
        view.font = .medium(12)
        view.textColor = Assets.Colors.mediumGray
        return view
    }()

    private let button: UILabel = {
        let view = UILabel()
        view.font = .medium(12)
        view.textColor = Assets.Colors.accentColor
        view.isUserInteractionEnabled = true
        return view
    }()

    private let bigLabelContainer = UIView()

    private let bigLabel: UILabel = {
        let view = UILabel()
        view.font = .bold(20)
        view.textColor = Assets.Colors.black
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        addSubview(stackView)
        stackView.addArrangedSubview(topContainer)
        stackView.addArrangedSubview(bigLabelContainer)
        topContainer.addSubview(label)
        topContainer.addSubview(button)
        bigLabelContainer.addSubview(bigLabel)
    }

    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        label.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        button.snp.remakeConstraints { make in
            make.left.equalTo(label.snp.right).offset(8)
            make.right.top.equalToSuperview()
            make.height.equalTo(20)
        }
        bigLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        super.setupConstraints()
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onButtonTap))
        button.addGestureRecognizer(tap)
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        label.text = model.text?.uppercased()
        topContainer.isHidden = model.text == nil

        button.text = model.buttonText
        button.isHidden = model.buttonText == nil

        bigLabel.text = model.bigLabelText
        bigLabelContainer.isHidden = model.bigLabelText == nil

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onButtonTap() {
        onAction?(.buttonTap)
    }
}

