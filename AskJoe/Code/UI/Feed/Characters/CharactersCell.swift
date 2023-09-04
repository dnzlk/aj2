//
//  CharactersCell.swift
//  AskJoe
//
//  Created by Денис on 18.03.2023.
//

import UIKit

final class CharactersCell: Cell<[Person], CharactersCell.Action> {

    static let reuseId = String(describing: CharactersCell.self)

    // MARK: - Types

    enum Action {
        case tap(Person)
    }

    // MARK: - Private Properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 0)
        return scrollView
    }()

    private let carouselStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = .clear

        selectionStyle = .none

        contentView.addSubview(scrollView)
        scrollView.addSubview(carouselStackView)
    }

    override func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        carouselStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.height.equalTo(120)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        carouselStackView.removeAllArrangedSubviews()

        for person in model {
            let view = CharacterView(model: person)
            view.snp.remakeConstraints { make in
                make.size.equalTo(120)
            }
            view.onAction = { [weak self] action in
                switch action {
                case .tap:
                    self?.onAction?(.tap(person))
                }
            }
            carouselStackView.addArrangedSubview(view)
        }
        super.reloadData(animated: animated)
    }
}
