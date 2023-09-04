//
//  ScenariosView.swift
//  AskJoe
//
//  Created by Денис on 29.05.2023.
//

import UIKit

final class ScenariosView: View<ScenariosView.Model, ScenariosView.Action> {

    // MARK: - Types

    struct Model {

        let style: Style
    }

    enum Action {
        case tapOnPerson(Person)
        case refresh
    }

    enum Style {
        case loading
        case loaded(persons: [Person])
    }

    // MARK: - Private Properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = Assets.Colors.solidWhite
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collection.addSubview(refreshControl)
        return collection
    }()
    private let refreshControl = UIRefreshControl()
    private lazy var skeletonView = SkeletonLoaderView(model: .init(cells: [
        .space(8),
        .skeleton(FeedView.Skeleton())
    ]))

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = Assets.Colors.solidWhite

        addSubview(collectionView)
        addSubview(skeletonView)

        collectionView.register(ScenarioCharacterCell.self, forCellWithReuseIdentifier: ScenarioCharacterCell.reuseId)

        collectionView.contentInset = .init(top: 0, left: 0, bottom: safeAreaInsets.bottom + 70, right: 0)
    }

    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        skeletonView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(collectionView.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        switch model.style {
        case .loading:
            updateSkeletonVisibility(hidden: false)
        case .loaded:
            updateSkeletonVisibility(hidden: true)
            collectionView.reloadData()
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Public Methods

    func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
    }

    // MARK: - Private Methods

    private func updateSkeletonVisibility(hidden: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.skeletonView.alpha = hidden ? 0 : 1
            self.collectionView.alpha = hidden ? 1 : 0
        }
        hidden ? skeletonView.stopLoading() : skeletonView.startLoading()
    }

    @objc
    private func refresh() {
        onAction?(.refresh)
        refreshControl.endRefreshing()
    }
}

// MARK: -  UICollectionViewDataSource

extension ScenariosView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard case .loaded(let persons) = model?.style else { return 0 }

        return persons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard case .loaded(let persons) = model?.style else { return UICollectionViewCell() }

//        if indexPath.item == 0 {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterBannerCell.reuseId, for: indexPath) as? CharacterBannerCell else {
//                return UICollectionViewCell()
//            }
//            let person = persons[0]
//            cell.model = .init(snippet: .init(title: "Welcome \(person.name)", image: person.avatarUrl, description: nil, buttonText: "Try it now!"))
//            cell.onAction = { [weak self] action in
//                switch action {
//                case .tap:
//                    self?.onAction?(.tapOnPerson(person))
//                }
//            }
//
//            return cell
//        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScenarioCharacterCell.reuseId, for: indexPath) as? ScenarioCharacterCell else {
            return UICollectionViewCell()
        }
        let person = persons[indexPath.item]

        cell.model = person
        cell.onAction = { [weak self] action in
            guard case .tap = action else { return }

            self?.onAction?(.tapOnPerson(person))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ScenariosView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width

        if indexPath.item == 0 {
            return .init(width: viewWidth, height: 136)
        }

        let size = ((viewWidth - 8) / 2) - 1

        print("SOOQA ", size)
        return .init(width: size, height: size)
    }
}
