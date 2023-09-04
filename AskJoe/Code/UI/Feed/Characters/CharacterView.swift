//
//  CharacterView.swift
//  AskJoe
//
//  Created by Денис on 18.03.2023.
//

import UIKit
import Nuke

final class CharacterView: View<Person, TapOnlyAction> {

    // MARK: - Private Properties

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

//    private let gradientView: UIView = {
//        let view = UIView()
//        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.45).cgColor]
//        gradient.locations = [0, 1]
//        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
//        gradient.frame = .init(x: 0, y: 0, width: 120, height: 120)
//        view.layer.insertSublayer(gradient, at: 0)
//        return view
//    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(14)
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()

    // MARK: - Lifecycle

    override func make() {
        super.make()

        roundCorners(18)
        clipsToBounds = true

        addSubview(imageView)
//        addSubview(gradientView)
        addSubview(titleLabel)
    }

    override func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)

        super.bind()
    }

    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        gradientView.snp.makeConstraints { make in
//            make.edges.equalTo(imageView.snp.edges)
//        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(8)
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        titleLabel.text = model.name

        if let avatarUrl = model.avatarUrl, let url = URL(string: avatarUrl) {
            Task { imageView.image = try? await ImagePipeline.shared.image(for: url) }
        }
    }

    // MARK: - Private Methods

    @objc
    private func onTap() {
        onAction?(.tap)
    }
}
