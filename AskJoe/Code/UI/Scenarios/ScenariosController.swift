//
//  ScenariosController.swift
//  AskJoe
//
//  Created by Денис on 31.05.2023.
//

import UIKit

final class ScenariosController: ViewController {

    // MARK: - Private Properties

    private var scenariosView = ScenariosView()

    private var characters: [Person] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScenariosView()
        Task { await loadCharacters() }
    }

    // MARK: - Private Methods

    private func addScenariosView() {
        view.addSubview(scenariosView)
        scenariosView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func loadCharacters() async {
        scenariosView.model = .init(style: .loading)
        characters = (try? await  CharactersEndpoint.shared.load()) ?? []
        scenariosView.model = .init(style: .loaded(persons: characters))
    }
}
