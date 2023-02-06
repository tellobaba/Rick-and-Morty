//
//  RMCharacterViewController.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 01/02/2023.
//

import UIKit

///Controller to search and show for characters
final class RMCharacterViewController: UIViewController {
    
    private let characterListView = CharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
    }
    private func setupView(){
        view.addSubview(characterListView)
        NSLayoutConstraint.activate(
        [
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
