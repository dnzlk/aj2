//
//  FeedController.swift
//  AskJoe
//
//  Created by Денис on 14.02.2023.
//

import AppTrackingTransparency
import DifferenceKit
import UIKit

final class FeedController: ViewController {

    // MARK: - Types

    private enum Const {
        static let feedLoadLimit = 10
        static let appState = "appState"
    }

    // MARK: - Private Properties

    private var feedView = FeedView()

    private let db = DataManager.shared
    private let nm = NotificationsManager.shared
    private let pm = PurchaseManager.shared

    private let freeMessagesStorage = SecureStore(secureStoreQueryable: GenericPasswordQueryable(key: .numberOfMessagesLeftToday))
    private let freeImagesStorage = SecureStore(secureStoreQueryable: GenericPasswordQueryable(key: .numberOfImagesLeftToday))

    private var feed: [FeedItem] = []
    private var characters: [Person] = []
    private var imageGeneratorImage: AMFeedImageResponse?

    private var offset = 0
    private var canLoadNext = true

    private var isFirstDataLoaded = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        nm.addObserver(self)

        openOnboardingIfNeeded()

        addFeedView()

        initialLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard isFirstDataLoaded else { return }

        updateTable()
    }

    override func bind() {
        feedView.onAction = { [weak self] action in
            switch action {
            case let .openPost(item):
                self?.openPost(item: item)
            case let .tapOnPrompt(prompt):
                self?.openChat(prompt: prompt)
            case let .tapOnPerson(person):
                Task { await self?.openPreviousChatWithPerson(person: person) }
            case let .openImageGenerator(string):
                self?.openImageGenerator(prompt: string)
            case .openPayment:
                self?.openPayment()
            case .refresh:
                self?.initialLoad()
            case .loadNext:
                Task {
                    _ = await self?.loadFeed()
                    self?.updateTable()
                }
            }
        }
        super.bind()
    }

    // MARK: - Public Methods

    func scrollToTop() {
        feedView.scrollToTop()
    }

    // MARK: - Private Methods

    private func addFeedView() {
        view.addSubview(feedView)
        feedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func initialLoad() {
        func updateTable() {
            self.updateTable()
            isFirstDataLoaded = true
        }
        canLoadNext = true
        isFirstDataLoaded = false
        feedView.model = .init(style: .loading)

        resetFreeMessagesAndPhotosIfNeeded()

        Task {
            await loadFeed(needsToRemoveOld: true)
            updateTable()
        }
        Task {
            await loadCharacters()
            updateTable()
        }
        Task {
            await loadImageGeneratorImage()
            updateTable()
        }
    }

    private func openChat(chat: Chat? = nil,
                          prompt: Prompt? = nil,
                          person: Person? = nil,
                          onBackButtonPressed: (() -> Void)? = nil) {
        let vc = ChatController(chat: chat, prompt: prompt, person: person)
        vc.onBackPressed = onBackButtonPressed
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openImageGenerator(prompt: String) {
        let vc = ImageGeneratorController(defaultPrompt: prompt)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private func openPreviousChatWithPerson(person: Person) async {
        let chats = await db.getChats()

        if let chat = chats.first(where: { $0.person?.characterId == person.characterId }) {
            openChat(chat: chat)
        } else {
            openChat(person: person)
        }
    }

    private func openSettings() {
        let vc = SettingsController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openHistory() {
        let controller = HistoryController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func openPost(item: FeedItem) {
        switch item.type {
        case let .post(snippet, blocks):
            let post = Post(title: snippet.title ?? "", blocks: blocks, createdAt: item.publishedAt)
            let controller = PostDetailsController(post: post)
            navigationController?.pushViewController(controller, animated: true)
        case let .externalPost(_, url):
            openBrowser(url: url)
        case .newCharacter, .prompt:
            break
        }
    }

    private func openOnboardingIfNeeded() {
        let ud = UserDefaultsManager.shared

        guard ud.getStartingDay() == 0 else {
            requestTrackingAuthorization()

            return
        }

        ud.saveStartingDay(date: Date())

        let vc = OnboardingController()
        vc.onSkipPressed = { [weak self] in
            self?.requestTrackingAuthorization()
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private func updateTable() {
        var newData: [FeedView.SectionData] = []

        if !pm.hasUnlockedFullAccess && pm.hasLoadedPurchasedInfoAtLeastOnce {
            let freeMessagesLeft = Int((try? freeMessagesStorage.getValue()?.0) ?? "0") ?? 0
            let freeImagesLeft = Int((try? freeImagesStorage.getValue()?.0) ?? "0") ?? 0

            newData.append(.init(model: .trialPeriod, elements: [.trial(messages: freeMessagesLeft, images: freeImagesLeft)]))
        }
        if let imageGeneratorImage {
            newData.append(.init(model: .imageGenerator, elements: [.imageGenerator(imageGeneratorImage)]))
        }
        if !characters.isEmpty {
            newData.append(.init(model: .askFamousPerson, elements: [.characters(characters)]))
        }
        if !feed.isEmpty {
            let feedModels: [FeedCellModel] = feed.map { .feed($0) }
            newData.append(.init(model: .feed, elements: feedModels))
        }
        feedView.model = .init(style: .loaded(sections: newData))
    }

    private func loadFeed(needsToRemoveOld: Bool = false) async {
        guard canLoadNext else { return }

        FBAnalytics.log(.feed_started_loading)

        canLoadNext = false

        do {
            FBAnalytics.log(.feed_loaded, params: [Const.appState: UIApplication.shared.applicationState.rawValue])

            if needsToRemoveOld {
                offset = 0
                feed.removeAll()
            }
            let newItems = try await FeedEndpoint.shared.load(offset: offset, limit: Const.feedLoadLimit)
            feed += newItems
            offset += Const.feedLoadLimit
            canLoadNext = newItems.count == Const.feedLoadLimit
        } catch {
            FBAnalytics.log(.feed_error_loading, params: [Const.appState: UIApplication.shared.applicationState.rawValue])
        }
    }

    private func loadCharacters() async {
        characters = (try? await  CharactersEndpoint.shared.load()) ?? []
    }

    private func loadImageGeneratorImage() async {
        guard imageGeneratorImage == nil else { return }

        imageGeneratorImage = try? await FeedImageEndpoint.shared.load()
    }

    private func resetFreeMessagesAndPhotosIfNeeded() {
        // Free messages
        if let freeMessagesValues = try? freeMessagesStorage.getValue() {
            let createdAt = freeMessagesValues.1

            guard !Calendar.current.isDateInToday(createdAt) else { return }

            try? freeMessagesStorage.set(value: "\(GlobalConst.freeMessagesCount)", shouldRemoveOld: true)
        } else {
            try? freeMessagesStorage.set(value: "\(GlobalConst.freeMessagesCount)", shouldRemoveOld: true)
        }

        // Free images
        if let freeImagesValues = try? freeImagesStorage.getValue() {
            let createdAt = freeImagesValues.1

            guard !Calendar.current.isDateInToday(createdAt) else { return }

            try? freeImagesStorage.set(value: "\(GlobalConst.freeImagesCount)", shouldRemoveOld: true)
        } else {
            try? freeImagesStorage.set(value: "\(GlobalConst.freeImagesCount)", shouldRemoveOld: true)
        }
    }

    private func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { (status) in
          switch status {
          case .denied:
              print("AuthorizationStatus is denied")
          case .notDetermined:
              print("AuthorizationStatus is notDetermined")
          case .restricted:
              print("AuthorizationStatus is restricted")
          case .authorized:
              print("AuthorizationStatus is authorized")
          @unknown default:
              print("Invalid authorization status")
          }
        }
    }
}

// MARK: - NotificationsObserver

extension FeedController: NotificationsObserver {

    func onEvent(_ event: NotificationsManager.Event) {
        switch event {
        case .chatUpdated, .chatsRemoved:
            break
        case .subscriptionInfoUpdated:
            guard isFirstDataLoaded else { return }
            
            updateTable()
        }
    }
}
