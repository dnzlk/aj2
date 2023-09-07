//
//  View.swift
//  texy
//
//  Created by Denis Khabarov on 24.11.2022.
//

import UIKit

class _View<Model, Action>: UIView {

    var model: Model? {
        didSet {
            reloadData(animated: false)
        }
    }

    var onAction: ((Action) -> Void)?

    init() {
        super.init(frame: .zero)
        make()
        setupConstraints()
        bind()
        reloadData(animated: false)
    }

    init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        make()
        setupConstraints()
        bind()
        reloadData(animated: false)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func make() {}

    func setupConstraints() {}

    func bind() {}

    func reloadData(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.4) {
                self.layoutIfNeeded()
            }
        } else {
            setNeedsLayout()
        }
    }

    func applyModelChanges(animated: Bool = false, transform: (inout Model) -> Void) {
        guard var model else {
            return
        }
        transform(&model)
        self.model = model
        reloadData(animated: animated)
    }
}

struct EmptyModel { }

enum EmptyAction { }

enum TapOnlyAction {
    case tap
}
