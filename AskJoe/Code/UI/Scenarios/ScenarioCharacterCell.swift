//
//  ScenarioCharacterCell.swift
//  AskJoe
//
//  Created by Денис on 31.05.2023.
//

import UIKit

final class ScenarioCharacterCell: CollectionCell<Person, TapOnlyAction> {

    static let reuseId = String(describing: ScenarioCharacterCell.self)

    // MARK: - Private Properties

    private let characterView = CharacterView()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        addSubview(characterView)
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func setupConstraints() {
        characterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        characterView.model = model

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
