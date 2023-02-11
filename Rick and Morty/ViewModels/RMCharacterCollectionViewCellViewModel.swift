//
//  RMCharacterCollectionViewCellViewModel.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 06/02/2023.
//

import Foundation
import UIKit

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable{

    public  let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageURL: URL?

    //MARK: - Init
    init(characterName: String,
         characterStatus: RMCharacterStatus,
         characterImageURL: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }
    
    public var characterStatusText: String{
        return "Status: \(characterStatus.text )"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>)->Void){
        //Todo: abstract to image manager
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
             
            return
        }
      
        RMImageLoader.shared.downLoadImage(url, completion: completion)
    }
    //MARK: - Hasable
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
}
