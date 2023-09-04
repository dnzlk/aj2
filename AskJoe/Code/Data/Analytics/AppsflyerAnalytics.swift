//
//  AppsflyerAnalytics.swift
//  AskJoe
//
//  Created by Денис on 25.04.2023.
//

import AppsFlyerLib
import Foundation
import StoreKit

class AppsflyerAnalytics {

    static func logPurchase(_ transaction: Transaction, product: Product) {
        AppsFlyerLib.shared().validateAndLog(inAppPurchase: transaction.productID,
                                             price: product.price.description,
                                             currency: product.priceFormatStyle.currencyCode,
                                             transactionId: String(transaction.id),
                                             additionalParameters: nil,
                                             success: nil)
    }
}
