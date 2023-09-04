//
//  Constraints.swift
//  texy
//
//  Created by Denis Khabarov on 23.11.2022.
//

import UIKit

// MARK: - Round Corners

extension UIView {

    func roundCorners(_ radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.cornerCurve = .continuous
    }
}

// MARK: - Show/Hide

extension UIView {

    func showWithAnimation(time: Double = 0.4) {
        UIView.animate(withDuration: time) {
            self.alpha = 1
        }
    }

    func hideWithAnimation(time: Double = 0.4) {
        UIView.animate(withDuration: time) {
            self.alpha = 0
        }
    }
}
