//
//  JoeIsTypingView.swift
//  AskJoe
//
//  Created by Денис on 21.02.2023.
//

import UIKit

final class JoeIsTypingCell: Cell<EmptyModel, EmptyAction> {

    static let reuseId = String(describing: JoeIsTypingCell.self)

    // MARK: - Private Properties

    private let label: UILabel = {
        let label = UILabel()
        label.font = .medium(14)
        label.textColor = Assets.Colors.dark
        return label
    }()

    private let dotsLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(14)
        label.textColor = Assets.Colors.dark
        label.text = ""
        return label
    }()

    private var timer: Timer?

    // MARK: - Lifecycle

    override func make() {
        backgroundColor = .clear
        
        addSubview(label)
        addSubview(dotsLabel)
    }

    override func setupConstraints() {
        label.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
        dotsLabel.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right)
            make.top.bottom.equalToSuperview()
        }
    }

    override func reloadData(animated: Bool) {
        startAnimating()

        label.text = "AJ is typing"

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    private func startAnimating() {
        timer?.invalidate()
        timer = nil

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            switch self?.dotsLabel.text {
            case "":
                self?.dotsLabel.text = "."
            case ".":
                self?.dotsLabel.text = ".."
            case "..":
                self?.dotsLabel.text = "..."
            default:
                self?.dotsLabel.text = ""
            }
        }
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}
