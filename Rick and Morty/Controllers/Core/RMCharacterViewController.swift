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
        
        let request = RMRequest(
            endpoint: .character)
        print(request.url)
    }
}
