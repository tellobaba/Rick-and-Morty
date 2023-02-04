//
//  RMCharacterViewController.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 01/02/2023.
//

import UIKit

///Controller to search and show for characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"

        RMService.shared.execute(.listCharactersRequests, expecting: RMGetCharactersResponse.self) {results in
            switch results {
            case .success (let model):
                print("Total: "+String(model.info.count))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
