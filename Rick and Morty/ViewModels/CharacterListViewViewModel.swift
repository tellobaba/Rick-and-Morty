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
                print("Total: "+String(model.info.count))
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath )
        cell.backgroundColor = .white
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
