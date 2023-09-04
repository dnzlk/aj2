//
//  PurchaseManager.swift
//  AskJoe
//
//  Created by Денис on 27.02.2023.
//

import Foundation
import StoreKit

// https://habr.com/ru/post/707730/
@MainActor
class PurchaseManager: NSObject {

    // MARK: - Types

    enum Subscription {
        case weekly
        case monthly

        // TODO: Remote
        var id: String {
            switch self {
            case .weekly:
                return "com.askjoe.ChatBot.weekly"
            case .monthly:
                return "com.askjoe.ChatBot.monthly3"
            }
        }
    }

    enum E: Error {
        case invalidId
        case brokenPhone
        case idFetchFailed
    }

    enum PurchaseResult {
        case success
        case needsAgreement
        case cancelled
        case failed
    }

    private struct IDS: Codable {

        var weekly: String
        var monthly: String
    }

    // MARK: - Public Properties

    static let shared = PurchaseManager()
    
    private(set) var products: [Product] = []

    private(set) var hasLoadedPurchasedInfoAtLeastOnce = false

    var hasUnlockedFullAccess: Bool {
       return !purchasedProductIDs.isEmpty
    }

    var weeklySub: Product? {
        products.first(where: { $0.id == Subscription.weekly.id })
    }
    
    var monthlySub: Product? {
        products.first(where: { $0.id == Subscription.monthly.id })
    }

    // MARK: - Private Properties

    private var purchasedProductIDs = Set<String>()
    private var updates: Task<Void, Never>? = nil
    private var productsLoaded = false

    private let nm = NotificationsManager.shared

    // MARK: - Init

    override init() {
        super.init()

        Task {
            try? await loadProducts()
            await updatePurchasedProducts()
        }
        updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        updates?.cancel()
    }

    // MARK: - Public Methods

    func purchase(sub: Subscription) async throws -> PurchaseResult {
        guard let product = products.first(where: {$0.id == sub.id}) else { throw E.invalidId }

        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await updatePurchasedProducts()
            AppsflyerAnalytics.logPurchase(transaction, product: product)
            
            return .success
        case .success(.unverified):
            throw E.brokenPhone
        case .pending:
            return .needsAgreement
        case .userCancelled:
            return .cancelled
        @unknown default:
            return .failed
        }
    }

    func restorePurchases() async throws {
        try await AppStore.sync()
    }

    // MARK: - Private Methods

    private func loadProducts() async throws {
        guard !productsLoaded else { return }
        let ids = (try? await loadIds()) ?? [Subscription.weekly.id, Subscription.monthly.id]
        products = try await Product.products(for: ids)
        productsLoaded = true
    }

    private func loadIds() async throws -> [String] {
        guard let url = URL(string: "https://chatbot-ios-backend.vercel.app/const/subs") else { throw E.idFetchFailed }

        let (data, _) = try await URLSession.shared.data(from: url)
        let ids = try JSONDecoder().decode(IDS.self, from: data)

        guard !ids.weekly.isEmpty && !ids.monthly.isEmpty else { throw E.idFetchFailed }

        return [ids.weekly, ids.monthly]
    }

    private func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            if transaction.revocationDate == nil {
                purchasedProductIDs.insert(transaction.productID)
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }
        hasLoadedPurchasedInfoAtLeastOnce = true
        nm.emit(.subscriptionInfoUpdated)
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await updatePurchasedProducts()
            }
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension PurchaseManager: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
