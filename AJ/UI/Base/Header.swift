//
//  Header.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import UIKit

class Header<Model, Action>: UITableViewHeaderFooterView {

    var model: Model? {
        didSet {
            reloadData(animated: false)
        }
    }

    var onAction: ((Action) -> Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        make()
        setupConstraints()
        bind()
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
