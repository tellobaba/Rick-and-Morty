//
//  CharacterListViewViewModel.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 06/02/2023.
//

import Foundation
import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject{
    func didLoadInitialCharacters()
}

final class CharacterListViewViewModel: NSObject{
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    private var characters: [RMCharacter] = []{
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageURL: URL(string: character.image)
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    public func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetCharactersResponse.self) { [weak self] results in
            switch results {
            case .success (let responseModel):
                let results = responseModel.results
                self?.characters = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
extension CharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath )
                as? RMCharacterCollectionViewCell else{
           fatalError("Unsupported Cell")
       }
        cell.configure(with: cellViewModels[indexPath.row])
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
