//
//  CharacterListViewViewModel.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 06/02/2023.
//

import Foundation
import UIKit

final class CharacterListViewViewModel: NSObject{
    
    func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetCharactersResponse.self) {results
            in
            switch results {
            case .success (let model):
                print("Example Image URL: "+String(model.results.first?.image ?? "No image"))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
extension CharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath )
                as? RMCharacterCollectionViewCell else{
           fatalError("Unsupported Cell")
       }
        let viewModel = RMCharacterCollectionViewCellViewModel(
            characterName: "Tello",
            characterStatus: .Alive,
            characterImageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
            
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width * 1.5
            )
    }
}
