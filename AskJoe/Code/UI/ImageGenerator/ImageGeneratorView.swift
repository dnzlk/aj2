//
//  ImageGeneratorView.swift
//  AskJoe
//
//  Created by Денис on 17.04.2023.
//

import UIKit

final class ImageGeneratorView: View<ImageGeneratorView.Model, ImageGeneratorView.Action> {

    // MARK: - Types

    struct Model {

        let state: State
    }

    enum State {
        case empty(defaultPrompt: String)
        case loading
        case loaded(String, onLoadedImage: ((UIImage?) -> Void))
        case error
    }

    enum Action {
        case request(String)
        case defaultPromptTap
        case save
        case share
        case errorTap
        case close
    }

    // MARK: - Private Properties

    private let navBar = NavBar(model: .init(backButtonImage: .init(named: "close")))
    private let container = UIView()
    private let placeholder = ImageGeneratorPlaceholder()
    private let loader = ImageGeneratorLoadingView()
    private let loadedView = ImageGeneratorLoadedView()
    private let errorView = ImageGeneratorErrorView()
    private let textField = ChatTextField(model: .init(placeholder: L10n.Images.typeYourRequest))

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = Assets.Colors.white

        addSubview(navBar)
        addSubview(textField)
        addSubview(container)
        container.addSubview(placeholder)
        container.addSubview(loader)
        container.addSubview(loadedView)
        container.addSubview(errorView)
    }

    override func bind() {
        navBar.onAction = { [weak self] action in
            switch action {
            case .backButtonTap:
                self?.onAction?(.close)
            case .rightButtonTap:
                break
            }
        }
        textField.onAction = { [weak self] action in
            switch action {
            case let .sendButtonTap(string):
                self?.onAction?(.request(string))
            case .onBecomeActive, .onBecomeInactive:
                break
            }
        }
        loadedView.onAction = { [weak self] action in
            switch action {
            case .share:
                self?.onAction?(.share)
            case .save:
                self?.onAction?(.save)
            }
        }
        placeholder.onAction = { [weak self] action in
            switch action {
            case .tap:
                self?.onAction?(.defaultPromptTap)
            }
        }
        errorView.onAction = { [weak self] action in
            switch action {
            case .tap:
                self?.onAction?(.errorTap)
            }
        }
        super.bind()
    }

    override func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(navBar.snp.bottom)
        }
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(container.snp.bottom)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        placeholder.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        loader.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        errorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        switch model.state {
        case let .empty(defaultPrompt):
            placeholder.showWithAnimation()
            loadedView.alpha = 0
            loader.alpha = 0
            errorView.hideWithAnimation()
            loader.stopLoading()
            container.showWithAnimation()
            placeholder.model = defaultPrompt
            textField.showWithAnimation()
        case .loading:
            errorView.hideWithAnimation()
            loadedView.alpha = 0
            loader.showWithAnimation()
            loader.startLoading()
            placeholder.hideWithAnimation()
            textField.hideWithAnimation()
        case let .loaded(request, onLoadedImage):
            errorView.hideWithAnimation()
            loadedView.model = .init(request: request, onLoadedImage: onLoadedImage)
            loadedView.showWithAnimation()
            textField.hideWithAnimation()
            placeholder.hideWithAnimation()
            loader.hideWithAnimation()
            loader.stopLoading()
        case .error:
            textField.hideWithAnimation()
            placeholder.hideWithAnimation()
            loadedView.hideWithAnimation()
            loader.hideWithAnimation()
            loader.stopLoading()
            errorView.showWithAnimation()
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Public Methods

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()

        return true
    }

    func clear() {
        textField.clear()
    }
}
