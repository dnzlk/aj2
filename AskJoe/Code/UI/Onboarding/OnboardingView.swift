//
//  OnboardingView.swift
//  AskJoe
//
//  Created by Денис on 23.02.2023.
//

import UIKit

final class OnboardingView: View<EmptyModel, OnboardingView.Action> {

    // MARK: - Types

    enum Action {
        case letsGoPressed
        case skipPressed
    }

    // MARK: - Private Properties

    private let topContainer = UIView()

    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Onboarding.skip.uppercased(), for: .normal)
        button.titleLabel?.font = .bold(14)
        button.setTitleColor(Assets.Colors.mediumGray, for: .normal)
        return button
    }()

    private let imageAndTextBigContainer = UIView()
    private let imageAndTextContainer = UIView()
    private let image = UIImageView(image: .init(named: "onboarding"))

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .heavy(24)
        label.numberOfLines = 0
        label.textColor = Assets.Colors.solidBlack
        label.text = L10n.Onboarding.superpower
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(16)
        label.textColor = Assets.Colors.mediumGray
        label.numberOfLines = 0
        label.text = "· \(L10n.Onboarding.learn)\n· \(L10n.Onboarding.writeBlog)\n· \(L10n.Onboarding.fixGrammar)\n· \(L10n.Onboarding.helpWithStudies)"
        return label
    }()

    private let letsGoButton: ButtonComponent = {
        let view = ButtonComponent()
        view.setTitle(L10n.Onboarding.tryItOut, for: .normal)
        view.titleLabel?.font = .medium(16)
        view.setTitleColor(Assets.Colors.textOnAccent, for: .normal)
        view.roundCorners(18)
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        backgroundColor = Assets.Colors.solidWhite

        addSubview(topContainer)
        addSubview(imageAndTextBigContainer)

        topContainer.addSubview(skipButton)

        imageAndTextBigContainer.addSubview(imageAndTextContainer)
        imageAndTextContainer.addSubview(image)
        imageAndTextContainer.addSubview(titleLabel)
        imageAndTextContainer.addSubview(descriptionLabel)

        addSubview(letsGoButton)
    }

    override func bind() {
        skipButton.addTarget(self, action: #selector(onSkipTap), for: .touchUpInside)
        letsGoButton.addTarget(self, action: #selector(onLetsGoTap), for: .touchUpInside)
    }

    override func setupConstraints() {
        topContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        skipButton.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(16)
        }

        imageAndTextBigContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topContainer.snp.bottom).offset(24)
        }
        imageAndTextContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(image.snp.bottom).offset(32)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        letsGoButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(imageAndTextBigContainer.snp.bottom).offset(24)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
            make.height.equalTo(56)
        }
    }

    // MARK: - Private Methods

    @objc
    private func onLetsGoTap() {
        onAction?(.letsGoPressed)
    }

    @objc
    private func onSkipTap() {
        onAction?(.skipPressed)
    }
}
