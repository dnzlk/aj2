//
//  Cell.swift
//  texy
//
//  Created by Denis Khabarov on 23.11.2022.
//

import UIKit

class Cell<Model, Action>: UITableViewCell {

    var model: Model? {
        didSet {
            reloadData(animated: false)
        }
    }

    var onAction: ((Action) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
