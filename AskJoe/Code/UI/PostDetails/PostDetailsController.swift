//
//  PostDetailsController.swift
//  AskJoe
//
//  Created by Денис on 30.03.2023.
//

import UIKit

final class PostDetailsController: ViewController {

    // MARK: - Private Properties

    private let postDetailsView = PostDetailsView()

    private let post: Post

    // MARK: - Init

    init(post: Post) {
        self.post = post
        super.init()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        postDetailsView.model = post
        addPostView()
    }

    override func bind() {
        postDetailsView.onAction = { [weak self] action in
            switch action {
            case .backButtonPressed:
                self?.navigationController?.popViewController(animated: true)
            }
        }
        super.bind()
    }

    // MARK: - Private Methods

    private func addPostView() {
        view.addSubview(postDetailsView)
        postDetailsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
