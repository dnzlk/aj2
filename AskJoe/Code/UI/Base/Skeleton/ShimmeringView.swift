//
//  ShimmeringView.swift
//  AskJoe
//
//  Created by Денис on 31.03.2023.
//

import UIKit

final class ShimmeringView: View<ShimmeringView.Model, EmptyAction> {

    // MARK: - Types

    enum Const {
        static let animationKey = "ShimmeringAnimation"
    }

    struct Model {

        let cornerRadius: CGFloat
        var style: Style

        init(cornerRadius: CGFloat = 4, style: Style = .normal) {
            self.cornerRadius = cornerRadius
            self.style = style
        }
    }

    enum Style {
        case normal
        case dark

        var layerColor: CGColor? {
            switch self {
            case .normal:
                return Assets.Colors.lightGray?.cgColor
            case .dark:
                return Assets.Colors.mediumGray?.cgColor
            }
        }

        var backgroundColor: CGColor? {
            switch self {
            case .normal:
                return Assets.Colors.lightGray?.cgColor
            case .dark:
                return Assets.Colors.mediumGray?.cgColor
            }
        }
    }

    // MARK: - Private Properties

    private var delayTimer: Timer?

    // MARK: - Lifecycle

    override func reloadData(animated: Bool) {
        guard let model = model else {
            super.reloadData(animated: animated)
            return
        }
        roundCorners(model.cornerRadius)
        layer.backgroundColor = model.style.layerColor

        super.reloadData(animated: animated)
    }

    // MARK: - Public Methods

    func startShimmering(withDelay delay: Double) {
        delayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.startShimmering()
        }
    }

    func startShimmering() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = model?.style.backgroundColor
        animation.toValue = UIColor.clear.cgColor
        animation.duration = 0.8
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.timingFunction = .init(name: .easeInEaseOut)
        layer.add(animation, forKey: Const.animationKey)
    }

    func stopShimmering() {
        delayTimer?.invalidate()
        layer.removeAnimation(forKey: Const.animationKey)
    }
}
