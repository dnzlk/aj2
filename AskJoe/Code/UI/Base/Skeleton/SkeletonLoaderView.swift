//
//  SkeletonLoaderView.swift
//  AskJoe
//
//  Created by Денис on 31.03.2023.
//

import UIKit

final class SkeletonLoaderView: View<SkeletonLoaderView.Model, EmptyAction> {

    // MARK: - Types

    public enum Cell {
        case skeleton(_ view: SkeletonableView)
        case space(_ size: CGFloat)
        case custom(view: UIView)
    }

    public struct Model {

        var cells: [Cell]

        public init(cells: [Cell]) {
            self.cells = cells
        }
    }

    // MARK: - Public Properties

    private(set) var isAnimating = false

    // MARK: - Private Properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private var shimmeringViews: [ShimmeringView] = []

    // MARK: - Lifecycle

    override func make() {
        super.make()

        backgroundColor = Assets.Colors.solidWhite

        addSubview(stackView)
    }

    override func setupConstraints() {
        stackView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()

            if case let .space(size) = model?.cells.first {
                make.top.equalTo(size)
            } else {
                make.top.equalTo(0)
            }
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }

        stackView.removeAllArrangedSubviews()
        shimmeringViews = []

        for cell in model.cells {
            switch cell {
            case let .skeleton(view):
                let skeletonView = view
                shimmeringViews += skeletonView.shimmeringViews
                stackView.addArrangedSubview(skeletonView)
            case let .space(size):
                if let lastView = stackView.arrangedSubviews.last {
                    stackView.setCustomSpacing(size, after: lastView)
                }
            case let .custom(view):
                stackView.addArrangedSubview(view)
            }
        }
        super.reloadData(animated: animated)
    }

    // MARK: - Public Methods

    public func startLoading() {
        isAnimating = true

        shimmeringViews.enumerated().forEach { (offset, view) in
            view.startShimmering(withDelay: TimeInterval(offset) / 14)
        }
    }

    public func stopLoading() {
        isAnimating = false

        shimmeringViews.forEach {
            $0.stopShimmering()
        }
    }
}
