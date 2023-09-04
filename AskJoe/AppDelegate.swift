//
//  AppDelegate.swift
//  AskJoe
//
//  Created by Денис on 14.02.2023.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseMessaging
import Nuke

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Private Properties

    private let ud = UserDefaultsManager.shared

    // MARK: - Public Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupFirebase(application: application)
        
        return true
    }

    // MARK: - Private Methods

    private func setupFirebase(application: UIApplication) {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .sound]])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {

    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
//        Task {
//            guard ud.isDebugMode(), let fcmToken else { return }
//
//            do {
//                try await ScheduleMessageEndpoint.shared.schedule(token: fcmToken)
//            } catch {
//                print(error)
//            }
//        }
    }
}
