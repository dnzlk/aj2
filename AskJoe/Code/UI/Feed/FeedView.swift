//
//  FeedView.swift
//  AskJoe
//
//  Created by Денис on 23.03.2023.
//

import DifferenceKit
import UIKit

final class FeedView: View<FeedView.Model, FeedView.Action> {

    // MARK: - Types

    struct Model {

        let style: Style
    }

    enum Action {
        case tapOnPerson(Person)
        case tapOnPrompt(Prompt)
        case openPost(item: FeedItem)
        case openPayment
        case refresh
        case loadNext
        case openImageGenerator(String)
    }

    enum Style {
        case loading
        case loaded(sections: [SectionData])
    }

    enum Section: Int, Differentiable {
        case imageGenerator
        case trialPeriod
        case askFamousPerson
        case feed
    }

    typealias SectionData = ArraySection<Section, FeedCellModel>

    // MARK: - Private Properties

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = Assets.Colors.solidWhite
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        table.showsVerticalScrollIndicator = false
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        table.addSubview(refreshControl)
        return table
    }()
    private let refreshControl = UIRefreshControl()

    private lazy var skeletonView = SkeletonLoaderView(model: .init(cells: [
        .space(8),
        .skeleton(FeedView.Skeleton())
    ]))
    private var sections: [SectionData] = []

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = Assets.Colors.solidWhite

        addSubview(tableView)
        addSubview(skeletonView)

        tableView.register(CharactersCell.self, forCellReuseIdentifier: CharactersCell.reuseId)
        tableView.register(FeedPostCell.self, forCellReuseIdentifier: FeedPostCell.reuseId)
        tableView.register(PromptCell.self, forCellReuseIdentifier: PromptCell.reuseId)
        tableView.register(CharacterBannerCell.self, forCellReuseIdentifier: CharacterBannerCell.reuseId)
        tableView.register(FreeTrialCell.self, forCellReuseIdentifier: FreeTrialCell.reuseId)
        tableView.register(FeedImageGeneratorCell.self, forCellReuseIdentifier: FeedImageGeneratorCell.reuseId)
        tableView.register(FeedSectionHeader.self, forHeaderFooterViewReuseIdentifier: FeedSectionHeader.reuseId)

        tableView.contentInset = .init(top: 0, left: 0, bottom: safeAreaInsets.bottom + 56, right: 0)
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        skeletonView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(tableView.snp.top)
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
        case let .loaded(newSections):
            updateSkeletonVisibility(hidden: true)

            let oldData = sections
            sections = newSections

            let diff = StagedChangeset(source: oldData, target: newSections)

            tableView.reload(using: diff, with: .bottom) { [weak self] data in
                self?.sections = data
            }
        case .loading:
            updateSkeletonVisibility(hidden: false)
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Public Methods

    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }

    // MARK: - Private Methods

    private func updateSkeletonVisibility(hidden: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.skeletonView.alpha = hidden ? 0 : 1
            self.tableView.alpha = hidden ? 1 : 0
        }
        hidden ? skeletonView.stopLoading() : skeletonView.startLoading()
    }

    @objc
    private func refresh() {
        onAction?(.refresh)
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension FeedView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedSectionHeader.reuseId) as? FeedSectionHeader
        let section = sections[section]

        switch section.model {
        case .imageGenerator:
            header?.model = .init(bigLabelText: "🖼️  \(L10n.Images.aiArtGenerator)")
        case .trialPeriod:
            return nil
        case .feed:
            header?.model = .init(bigLabelText: "🎈 \(L10n.Feed.explore)")
        case .askFamousPerson:
            header?.model = .init(bigLabelText: "🤩  \(L10n.Feed.characters)")
        }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].elements[indexPath.row]

        switch model {
        case let .imageGenerator(response):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedImageGeneratorCell.reuseId, for: indexPath) as? FeedImageGeneratorCell else { return UITableViewCell() }
            cell.model = .init(title: response.title, url: response.url)
            cell.onAction = { [weak self] action in
                switch action {
                case .tap:
                    self?.onAction?(.openImageGenerator(response.title))
                case .imageLoaded:
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
            return cell
        case let .trial(messages, images):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FreeTrialCell.reuseId, for: indexPath) as? FreeTrialCell else { return UITableViewCell() }

            cell.model = .init(messages: messages, images: images)
            cell.onAction = { [weak self] action in
                switch action {
                case .tap:
                    self?.onAction?(.openPayment)
                }
            }
            return cell
        case let .characters(characters):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersCell.reuseId, for: indexPath) as? CharactersCell else { return UITableViewCell() }

            cell.model = characters
            cell.onAction = { [weak self] action in
                switch action {
                case let .tap(person):
                    self?.onAction?(.tapOnPerson(person))
                }
            }
            return cell

        case let .feed(item):
            switch item.type {
            case let .prompt(prompt, title):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PromptCell.reuseId, for: indexPath) as? PromptCell else { return UITableViewCell() }

                cell.model = .init(style: .prompt(prompt: prompt, title: title))
                cell.onAction = { [weak self] action in
                    switch action {
                    case .tap:
                        self?.onAction?(.tapOnPrompt(prompt))
                    }
                }
                return cell
            case .post, .externalPost:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostCell.reuseId, for: indexPath) as? FeedPostCell else { return UITableViewCell() }

                cell.model = item
                cell.onAction = { [weak self] action in
                    switch action {
                    case .tap:
                        self?.onAction?(.openPost(item: item))
                    case .imageLoaded:
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                }
                return cell
            case let .newCharacter(snippet, character):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterBannerCell.reuseId, for: indexPath) as? CharacterBannerCell else { return UITableViewCell() }

                cell.model = .init(snippet: snippet)

                cell.onAction = { [weak self] action in
                    switch action {
                    case .tap:
                        self?.onAction?(.tapOnPerson(character))
                    }
                }
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)

        if numberOfRows - indexPath.row == 2 {
            onAction?(.loadNext)
        }
    }
}

extension FeedView: UITableViewDelegate {}

extension FeedView: Skeletonable {

    final class Skeleton: View<EmptyModel, EmptyAction>, SkeletonableView {

        // MARK: - Public Properties

        var shimmeringViews: [ShimmeringView] {
            [banner1, banner2, banner3, banner4, banner5]
        }

        // MARK: - Private Properties

        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = 16
            stackView.axis = .vertical
            stackView.alignment = .leading
            return stackView
        }()

        private let banner1 = ShimmeringView(model: .init(cornerRadius: 12))
        private let banner2 = ShimmeringView(model: .init(cornerRadius: 12))
        private let banner3 = ShimmeringView(model: .init(cornerRadius: 12))
        private let banner4 = ShimmeringView(model: .init(cornerRadius: 12))
        private let banner5 = ShimmeringView(model: .init(cornerRadius: 12))


        // MARK: - Lifecycle

        override func make() {
            super.make()

            backgroundColor = .clear
            addSubview(stackView)
            stackView.addArrangedSubviews([banner1, banner2, banner3, banner4, banner5])
        }

        override func setupConstraints() {
            stackView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.bottom.equalToSuperview()
            }
            banner1.snp.remakeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(136)
            }
            banner2.snp.remakeConstraints { make in
                make.size.equalTo(120)
            }
            banner3.snp.remakeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(220)
            }
            banner4.snp.remakeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(80)
            }
            banner5.snp.remakeConstraints { make in
                make.size.equalTo(120)
            }
            super.setupConstraints()
        }
    }
}
