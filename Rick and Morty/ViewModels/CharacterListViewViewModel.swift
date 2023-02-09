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
    func didSelectCharacter(_ character: RMCharacter)
}


///View Model to handle character list view logic
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
    
    private var apiInfo: RMGetCharactersResponse.Info? = nil
    
    /////MARK: - Fetch initial set of 20 characters
    public func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetCharactersResponse.self) { [weak self] results in
            switch results {
            case .success (let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginate if additional characters are needed  
    public func fetchAdditionalCharacters(){
        //fetch characters
    }
    
    public var shouldShowLoadMoreIndicator: Bool{
        return apiInfo?.next != nil
    }
}

/// Collection View
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

//MARK: - Scroll View
extension CharacterListViewViewModel:  UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator else {
            return
        }
    }
}

