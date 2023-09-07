//
//  Analytics.swift
//  AskJoe
//
//  Created by Денис on 24.02.2023.
//

import FirebaseAnalytics
import Foundation

class FBAnalytics {

    static func log(_ key: AnalyticsKey, params: [String: Any]? = nil) {
        Analytics.logEvent(key.rawValue, parameters: params)
    }
}
