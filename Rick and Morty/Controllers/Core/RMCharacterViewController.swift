//
//  RMCharacterViewController.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 01/02/2023.
//

import UIKit

///Controller to search and show for characters
final class RMCharacterViewController: UIViewController, CharacterListViewDelegate  {
    
    private let characterListView = CharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
    }
    private func setupView(){
        characterListView.delegate = self 
        view.addSubview(characterListView)
        NSLayoutConstraint.activate(
        [
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func rmCharacterListView(_ characterListView: CharacterListView, didSelectCharacter character: RMCharacter) {
        //Open detail controller for character
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
     }
}
