//
//  ImageView.swift
//  AskJoe
//
//  Created by Денис on 01.04.2023.
//

import Nuke
import UIKit

final class ImageView: View<ImageView.Model, EmptyAction> {

    // MARK: - Types

    struct Model {

        let urlString: String
        var height: CGFloat = 150
        var radius: CGFloat = 16
        var onImageLoaded: ((UIImage?) -> Void)? = nil
    }

    // MARK: - Private Properties

    private let imageView: ScaledHeightImageView = {
        let imageView = ScaledHeightImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.lightGray?.withAlphaComponent(0.2)
        return view
    }()
    private let indicator = UIActivityIndicatorView(style: .medium)

    private let pipeline = ImagePipeline.shared

    // MARK: - Lifecycle

    override func make() {
        super.make()

        clipsToBounds = true

        addSubview(imageView)
        addSubview(loadingView)
        loadingView.addSubview(indicator)
    }

    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        super.setupConstraints()
    }

    override func reloadData(animated: Bool) {
        guard let model else {
            super.reloadData(animated: animated)
            return
        }
        guard let url = URL(string: model.urlString) else {
            return
        }
        if pipeline.cache.containsData(for: .init(url: url)) {
            updateLoadingViewVisibility(hidden: true)

            Task {
                let image = try? await ImagePipeline.shared.image(for: url)
                imageView.image = image
                model.onImageLoaded?(image)
            }
        } else {
            Task {
                updateLoadingViewVisibility(hidden: false)
                let image = try? await ImagePipeline.shared.image(for: url)
                imageView.image = image
                updateLoadingViewVisibility(hidden: true)
                model.onImageLoaded?(image)
            }
        }
        roundCorners(model.radius)

        super.reloadData(animated: animated)
    }

    // MARK: - Private Methods

    private func updateLoadingViewVisibility(hidden: Bool) {
        imageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            if !hidden, let height = model?.height {
                make.height.equalTo(height)
            }
        }
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.loadingView.alpha = hidden ? 0 : 1
        }
        hidden ? indicator.stopAnimating() : indicator.startAnimating()
    }
}

class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }
}
