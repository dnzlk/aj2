//
//  DateCell.swift
//  AJ
//
//  Created by Денис on 07.09.2023.
//

import UIKit

final class DateCell: Cell<DateCell.Model, EmptyAction> {

    static let reuseId = String(describing: DateCell.self)

    // MARK: - Types

    struct Model {

        let date: Date
    }

    // MARK: - Private Properties

    private let label: UILabel = {
        let label = UILabel()
        label.font = .regular(12)
        label.textColor = Assets.Colors.dark
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        backgroundColor = .clear
        selectionStyle = .none

        addSubview(label)
    }

    override func setupConstraints() {
        label.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(36)
        }
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }

        label.text = model.date.formatMessageDate

        super.reloadData(animated: animated)
    }
}

extension Date {

    static private let dayFormatter = DateFormatter()

    var formatMessageDate: String {
        Self.dayFormatter.dateFormat = "MMMM d"

        if Calendar.current.isDateInToday(self) {
            return "Today"
        }
        if Calendar.current.isDateInYesterday((self)) {
            return "Yestarday"
        }
        return Self.dayFormatter.string(from: (self))
    }
}
