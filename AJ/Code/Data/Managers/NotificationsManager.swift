//
//  NotificationsManager.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import Foundation

protocol NotificationsObserver: AnyObject {
    func onEvent(_ event: NotificationsManager.Event)
}

final class NotificationsManager {

    // MARK: - Types

    enum Event {
        case subscriptionInfoUpdated
    }

    typealias Observer = NotificationsObserver

    // MARK: - Public Properties

    static let shared = NotificationsManager()

    // MARK: - Private Properties

    private var observers = [() -> NotificationsObserver?]()

    // MARK: - Public Methods

    func addObserver(_ object: Observer) {
        observers.append { [weak object] in
            object
        }
    }

    func emit(_ event: Event) {
        DispatchQueue.main.async {
            self.observers.forEach { $0()?.onEvent(event) }
        }
    }
}
