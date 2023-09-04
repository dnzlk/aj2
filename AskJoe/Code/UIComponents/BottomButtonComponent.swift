//
//  BottomButtonComponent.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import UIKit

final class BottomButtonComponent: View<BottomButtonComponent.Model, BottomButtonComponent.Action> {

    // MARK: - Types

    struct Model {

        let text: String
        var backgroundColor: UIColor? = .clear
    }

    enum Action {
        case tap
    }

    // MARK: - Private Properties

    private let button: ButtonComponent = {
        let view = ButtonComponent()
        view.titleLabel?.font = .medium(16)
        view.setTitleColor(Assets.Colors.textOnAccent, for: .normal)
        view.roundCorners(18)
        return view
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()
        
        addSubview(button)
    }

    override func setupConstraints() {
        button.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.bottom.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(56)
        }
        super.setupConstraints()
    }

    override func bind() {
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)

        super.bind()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        button.setTitle(model.text, for: .normal)
        backgroundColor = model.backgroundColor

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onButtonTap() {
        onAction?(.tap)
    }
}
