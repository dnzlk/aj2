//
//  OnboardingController.swift
//  AskJoe
//
//  Created by Денис on 23.02.2023.
//

import UIKit

final class OnboardingController: ViewController {

    // MARK: - Public Properties

    var onLetsGoPressed: (() -> Void)?
    var onSkipPressed: (() -> Void)?

    // MARK: - Private Properties

    private let onboardingView = OnboardingView(model: .init())

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addView()
    }

    override func bind() {
        onboardingView.onAction = { [weak self] action in
            switch action {
            case .skipPressed:
                self?.dismiss(animated: true) {
                    self?.onSkipPressed?()
                }
                FBAnalytics.log(.onboarding_skip)
            case .letsGoPressed:
                self?.dismiss(animated: true) {
                    self?.onSkipPressed?()
                }
                FBAnalytics.log(.onboarding_lets_go)
            }
        }
    }

    // MARK: - Private Methods

    private func addView() {
        view.addSubview(onboardingView)

        onboardingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
