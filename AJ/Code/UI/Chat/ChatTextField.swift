//
//  ChatTextView.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import UIKit

final class ChatTextField: _View<ChatTextField.Model, ChatTextField.Action> {

    // MARK: - Types

    struct Model {

        let placeholder: String
    }

    enum Action {
        case onBecomeActive
        case onBecomeInactive
        case sendButtonTap(String)
    }

    private enum Const {
        static let maxHeight: CGFloat = 172.0
    }

    // MARK: - Private Properties

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.solidWhite
        view.roundCorners(12)
        return view
    }()

    private lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .regular(16)
        view.textColor = Assets.Colors.black
        view.backgroundColor = .clear
        view.delegate = self
        view.isScrollEnabled = false
        view.textContainerInset = .zero
        return view
    }()

    private let sendButton: UIButton = {
        let view = UIButton()
        view.setImage(.init(named: "sendInactive"), for: .normal)
        return view
    }()

    private let placeholder: UILabel = {
        let view = UILabel()
        view.font = .regular(14)
        view.textColor = Assets.Colors.gray
        return view
    }()

    // MARK: - Public Methods

    // TODO: Change to model update
    func clear() {
        textView.text.removeAll()
        updateActivityState()
    }

    // MARK: - Lifecycle

    override func make() {
        addSubview(container)
        container.addSubview(textView)
        container.addSubview(sendButton)
        container.addSubview(placeholder)

        backgroundColor = UIColor(Assets.Colors.white)
    }

    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        textView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.height.greaterThanOrEqualTo(24).priority(.medium)
            make.height.lessThanOrEqualTo(Const.maxHeight)
        }
        sendButton.snp.remakeConstraints { make in
            make.left.equalTo(textView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(48)
        }
        placeholder.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.centerY.equalTo(textView.snp.centerY)
        }
    }

    override func bind() {
        sendButton.addTarget(self, action: #selector(onSendTap), for: .touchUpInside)
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        placeholder.text = model.placeholder
        updateActivityState()

        super.reloadData(animated: animated)
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()

        return true
    }

    // MARK: - Private Methods

    private func updateActivityState() {
        placeholder.isHidden = !textView.text.isEmpty
        
        if textView.text.isEmpty  {
            sendButton.setImage(.init(named: "sendInactive"), for: .normal)
        } else {
            sendButton.setImage(.init(named: "sendActive"), for: .normal)
        }
    }

    @objc
    private func onSendTap() {
        guard !textView.text.isEmpty else { return }

        onAction?(.sendButtonTap(textView.text))
    }
}

extension ChatTextField: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        onAction?(.onBecomeActive)
        
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        onAction?(.onBecomeInactive)

        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        updateActivityState()
        textView.isScrollEnabled = textView.contentSize.height >= Const.maxHeight
    }
}
