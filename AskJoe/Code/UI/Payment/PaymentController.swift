//
//  PaymentController.swift
//  AskJoe
//
//  Created by Денис on 16.02.2023.
//

import StoreKit
import UIKit

final class PaymentController: ViewController {

    // MARK: - Private Properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let paymentView = PaymentView()

    private let pm = PurchaseManager.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addScrollAndPaymentViews()
        updateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FBAnalytics.log(.payment_show)
    }

    override func bind() {
        paymentView.onAction = { [weak self] action in
            switch action {
            case .closeButtonTap:
                self?.dismiss(animated: true)
                FBAnalytics.log(.payment_close_tap)
            case .monthlyTap:
                self?.paymentView.applyModelChanges(transform: { model in
                    model.selectedSubscription = .monthly
                })
                FBAnalytics.log(.payment_monthly_tap)
            case .weeklyTap:
                self?.paymentView.applyModelChanges(transform: { model in
                    model.selectedSubscription = .weekly
                })
                FBAnalytics.log(.payment_weekly_tap)
            case .restoreButtonTap:
                Task { await self?.restore() }
                FBAnalytics.log(.payment_restore_tap)
            case .startTap:
                Task { await self?.purchase() }
                FBAnalytics.log(.payment_start_tap)
            case .termsTap:
                if let url = URL(string: "https://www.getaskjoe.com/terms") {
                    self?.openBrowser(url: url)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func addScrollAndPaymentViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(paymentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        paymentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
    }

    private func updateData() {
        guard let weekly = pm.weeklySub, let monthly = pm.monthlySub else {
            showAlert(text: L10n.Payments.somethingWentWrong)
            dismiss(animated: true)
            return
        }
        paymentView.model = .init(weeklySubPrice: weekly.displayPrice,
                                  monthlySubPrice: monthly.displayPrice,
                                  monthlySale: L10n.Payments.save20,
                                  selectedSubscription: .monthly)
    }

    private func purchase() async {
        guard let sub = paymentView.model?.selectedSubscription else { return }

        paymentView.applyModelChanges { model in
            model.isLoading = true
        }

        do {
            let result = try await pm.purchase(sub: sub)

            switch result {
            case .success:
                dismiss(animated: true)
            case .needsAgreement:
                showAlert(text: "Transaction needs 3rd party agreement") { [weak self] in
                    self?.dismiss(animated: true)
                }
            case .cancelled:
                break
            case .failed:
                showAlert(text: L10n.Payments.failed)
            }
        } catch {
            showAlert(text: L10n.Payments.failed)
        }
        paymentView.applyModelChanges { model in
            model.isLoading = false
        }
    }

    private func restore() async {
        do {
            try await pm.restorePurchases()
            showAlert(text: L10n.Payments.restored)
        }
        catch {
            showAlert(text: L10n.Payments.somethingWentWrong)
        }
    }

    private func showAlert(text: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(.init(title: L10n.Payments.okay, style: .cancel, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
}
