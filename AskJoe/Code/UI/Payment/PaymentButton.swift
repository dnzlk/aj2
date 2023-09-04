//
//  PaymentButton.swift
//  AskJoe
//
//  Created by Денис on 17.02.2023.
//

import UIKit

final class PaymentButton: View<PaymentButton.Model, PaymentButton.Action> {

    // MARK: - Types

    struct Model {

        var title: String
        var price: String
        var sale: String? = nil
        var isSelected: Bool
    }

    enum Action {
        case tap
    }

    // MARK: - Private Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(18)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(14)
        return label
    }()

    private let saleContainer: UIView = {
        let view = UIView()
        view.roundCorners(9)
        view.backgroundColor = Assets.Colors.solidWhite
        return view
    }()

    private let saleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(10)
        label.textColor = Assets.Colors.accentColor
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        roundCorners(18)

        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(saleContainer)
        saleContainer.addSubview(saleLabel)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().offset(16)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        saleContainer.snp.remakeConstraints { make in
            make.top.right.equalToSuperview().inset(8)
            make.height.equalTo(18)
        }
        saleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(2)
        }
    }

    override func bind() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapRecognizer)
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        titleLabel.text = model.title
        priceLabel.text = model.price
        saleLabel.text = model.sale
        saleContainer.isHidden = model.sale == nil

        if model.isSelected {
            backgroundColor = Assets.Colors.accentColor
            layer.borderWidth = 0

            titleLabel.textColor = Assets.Colors.textOnAccent
            priceLabel.textColor = Assets.Colors.textOnAccent
        } else {
            backgroundColor = Assets.Colors.solidWhite
            layer.borderWidth = 1
            layer.borderColor = Assets.Colors.lightGray?.cgColor

            titleLabel.textColor = Assets.Colors.black
            priceLabel.textColor = Assets.Colors.dark
        }

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
