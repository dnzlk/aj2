//
//  ImageGeneratorController.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import UIKit

final class ImageGeneratorController: ViewController {

    // MARK: - Private Properties

    private let rootView = ImageGeneratorView()

    private let endpoint = ImageGeneratorEndpoint.shared

    private let defaultPrompt: String

    private var image: UIImage?

    private let pm = PurchaseManager.shared
    private let freeImagesStorage = SecureStore(secureStoreQueryable: GenericPasswordQueryable(key: .numberOfImagesLeftToday))

    // MARK: - Init

    init(defaultPrompt: String) {
        self.defaultPrompt = defaultPrompt
        super.init()
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRootView()
    }

    override func bind() {
        rootView.onAction = { [weak self] action in
            guard let self else { return }
            switch action {
            case let .request(request):
                Task { await self.send(request: request) }
            case .defaultPromptTap:
                Task { await self.send(request: self.defaultPrompt)}
            case .save:
                self.saveImageToLibrary(self.image)
            case .share:
                self.share()
            case .errorTap:
                self.rootView.model = .init(state: .empty(defaultPrompt: self.defaultPrompt))
            case .close:
                self.dismiss(animated: true)
            }
        }
        super.bind()
    }

    // MARK: - Private Methods

    private func send(request: String) async {
        let isDebug = UserDefaultsManager.shared.isDebugMode()
        let freeImagesCountLeft = Int((try? freeImagesStorage.getValue()?.0) ?? "0") ?? 0

        guard (pm.hasUnlockedFullAccess || freeImagesCountLeft > 0) || isDebug else {
            openPayment()
            return
        }
        var hasDecreasedFreeImagesCount = false

        rootView.endEditing(true)
        rootView.model = .init(state: .loading)

        if !pm.hasUnlockedFullAccess && !isDebug {
            try? freeImagesStorage.set(value: "\(freeImagesCountLeft - 1)")
            hasDecreasedFreeImagesCount = true
        }
        do {
            let url = try await endpoint.load(request: request)
            rootView.model = .init(state: .loaded(url, onLoadedImage: { [weak self] image in
                self?.image = image
            }))
        } catch {
            rootView.model = .init(state: .error)
            if hasDecreasedFreeImagesCount {
                try? freeImagesStorage.set(value: "\(freeImagesCountLeft)")
            }
        }
    }

    private func share() {
        guard let image else { return }

        share(items: [image])
    }

    private func addRootView() {
        view.addSubview(rootView)
        rootView.model = .init(state: .empty(defaultPrompt: defaultPrompt))
        rootView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
