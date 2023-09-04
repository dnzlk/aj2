//
//  SkeletonableController.swift
//  AskJoe
//
//  Created by Денис on 31.03.2023.
//

import UIKit

protocol SkeletonableController: UIViewController {

    var skeletonLoaderView: SkeletonLoaderView { get }

    var isSkeletonAnimating: Bool { get }

    func startSkeletonLoading(animated: Bool)
    func stopSkeletonLoading(animated: Bool)
}

extension SkeletonableController {

    var isSkeletonAnimating: Bool {
        skeletonLoaderView.isAnimating
    }

    func startSkeletonLoading(animated: Bool = true) {
        guard !isSkeletonAnimating else {
            return
        }

        if skeletonLoaderView.superview == nil {
            view.addSubview(skeletonLoaderView)
            skeletonLoaderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        skeletonLoaderView.alpha = 0
        view.bringSubviewToFront(skeletonLoaderView)

        skeletonLoaderView.startLoading()

        UIView.animate(withDuration: animated ? 0.4 : 0) {
            self.skeletonLoaderView.alpha = 1
        }
    }

    func stopSkeletonLoading(animated: Bool = true) {
        guard isSkeletonAnimating else {
            return
        }
        UIView.animate(withDuration: animated ? 0.4 : 0) {
            self.skeletonLoaderView.alpha = 0
        } completion: { _ in
            self.skeletonLoaderView.stopLoading()
            self.skeletonLoaderView.removeFromSuperview()
        }
    }
}

protocol Skeletonable {

    associatedtype Skeleton: SkeletonableView
}

protocol SkeletonableView: View<EmptyModel, EmptyAction> {

    var shimmeringViews: [ShimmeringView] { get }

    func startLoading()
    func stopLoading()
}

protocol StyledSkeletonableView: SkeletonableView {

    associatedtype Style

    static func with(style: Style) -> SkeletonableView
}

extension SkeletonableView {

    public func startLoading() {
        shimmeringViews.forEach { view in
            view.startShimmering()
        }
    }

    public func stopLoading() {
        shimmeringViews.forEach { view in
            view.stopShimmering()
        }
    }
}
