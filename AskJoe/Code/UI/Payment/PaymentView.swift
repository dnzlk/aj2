//
//  PaymentView.swift
//  AskJoe
//
//  Created by Денис on 17.02.2023.
//

import UIKit

final class PaymentView: View<PaymentView.Model, PaymentView.Action> {

    // MARK: - Types

    struct Model {

        var weeklySubPrice: String
        var monthlySubPrice: String
        var monthlySale: String?
        var selectedSubscription: PurchaseManager.Subscription
        var isLoading = false
    }

    enum Action {
        case restoreButtonTap
        case closeButtonTap
        case monthlyTap
        case weeklyTap
        case startTap
        case termsTap
    }

    // MARK: - Private Properties

    private let topContainer = UIView()

    private let restoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Payments.restorePurchase, for: .normal)
        button.setTitleColor(Assets.Colors.black, for: .normal)
        button.titleLabel?.font = .regular(14)
        return button
    }()
    private let closeButton: UIButton = {
        let view = UIButton()
        view.setImage(.init(named: "close"), for: .normal)
        return view
    }()

    private let imageAndTextBigContainer = UIView()
    private let imageAndTextContainer = UIView()
    private let notebookImage = UIImageView(image: .init(named: "notebook"))

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .heavy(24)
        label.textColor = Assets.Colors.solidBlack
        label.text = L10n.Payments.first3free
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(14)
        label.textColor = Assets.Colors.mediumGray
        label.numberOfLines = 0
        label.text = L10n.Payments.getAccess
        return label
    }()

    private let bottomContainer = UIView()
    private let monthlyButton = PaymentButton()
    private let weeklyButton = PaymentButton()

    private let saveButton: ButtonComponent = {
        let view = ButtonComponent()
        view.titleLabel?.font = .medium(16)
        view.setTitleColor(Assets.Colors.textOnAccent, for: .normal)
        view.roundCorners(18)
        return view
    }()

    private let termsOfUseLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(10)
        label.numberOfLines = 0
        label.textColor = Assets.Colors.mediumGray
        label.text = L10n.Payments.byTappingYouAgree
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()

    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.solidWhite?.withAlphaComponent(0.5)
        view.isHidden = false
        return view
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle

    override func make() {
        backgroundColor = Assets.Colors.solidWhite

        addSubview(topContainer)
        addSubview(imageAndTextBigContainer)
        addSubview(bottomContainer)
        addSubview(loadingView)

        topContainer.addSubview(restoreButton)
        topContainer.addSubview(closeButton)

        imageAndTextBigContainer.addSubview(imageAndTextContainer)
        imageAndTextContainer.addSubview(notebookImage)
        imageAndTextContainer.addSubview(titleLabel)
        imageAndTextContainer.addSubview(descriptionLabel)

        bottomContainer.addSubview(monthlyButton)
        bottomContainer.addSubview(weeklyButton)
        bottomContainer.addSubview(saveButton)
        bottomContainer.addSubview(termsOfUseLabel)

        loadingView.addSubview(activityIndicator)
    }

    override func bind() {
        saveButton.addTarget(self, action: #selector(onStartTap), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(onRestorePurchaseTap), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(onCloseTap), for: .touchUpInside)

        let termsTap = UITapGestureRecognizer(target: self, action: #selector(onTermsTap))
        termsOfUseLabel.addGestureRecognizer(termsTap)

        monthlyButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.monthlyTap)
        }
        weeklyButton.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.weeklyTap)
        }
    }

    override func setupConstraints() {
        topContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        restoreButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        closeButton.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }

        imageAndTextBigContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topContainer.snp.bottom).offset(24)
        }
        imageAndTextContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        notebookImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(notebookImage.snp.bottom).offset(32)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }

        bottomContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageAndTextBigContainer.snp.bottom).offset(24)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        monthlyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        weeklyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(monthlyButton.snp.bottom).offset(16)
        }
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(weeklyButton.snp.bottom).offset(32)
            make.height.equalTo(56)
        }
        termsOfUseLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(saveButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }

        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        saveButton.setTitle(L10n.Payments.start, for: .normal)

        monthlyButton.model = .init(title: L10n.Payments.monthly,
                                    price: "\(model.monthlySubPrice) / \(L10n.Payments.month)",
                                    sale: model.monthlySale,
                                    isSelected: model.selectedSubscription == .monthly)

        weeklyButton.model = .init(title: L10n.Payments.weekly,
                                   price: "\(model.weeklySubPrice) / \(L10n.Payments.week)",
                                   isSelected: model.selectedSubscription == .weekly)

        loadingView.isHidden = !model.isLoading

        if model.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onStartTap() {
        onAction?(.startTap)
    }

    @objc
    private func onRestorePurchaseTap() {
        onAction?(.restoreButtonTap)
    }

    @objc
    private func onCloseTap() {
        onAction?(.closeButtonTap)
    }

    @objc
    private func onTermsTap() {
        onAction?(.termsTap)
    }
}
