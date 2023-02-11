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
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}


///View Model to handle character list view logic
final class CharacterListViewViewModel: NSObject{
    
    private var isLoadingMoreCharacters: Bool = false
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    private var characters: [RMCharacter] = []{
       
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageURL: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetCharactersResponse.Info? = nil
    
    /////MARK: - Fetch initial set of 20 characters
    public func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequests,
                                 expecting: RMGetCharactersResponse.self) { [weak self] results in
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
    public func fetchAdditionalCharacters(url: URL){
        //fetch characters
        guard !isLoadingMoreCharacters else{
            return
        }
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else{
            isLoadingMoreCharacters = false
            return
        }
        RMService.shared.execute(request, expecting: RMGetCharactersResponse.self) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                 let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self?.delegate?.didLoadMoreCharacters(
                        with: indexPathToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacters = false

            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else{
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
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
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters, !cellViewModels.isEmpty,
        let nextURLString = apiInfo?.next,
        let url = URL(string: nextURLString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
          
            if offset >= (totalHeight - totalScrollViewFixedHeight - 120){
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate() 
        }
    }
}

