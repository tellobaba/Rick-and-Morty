//
//  RMCharacterCollectionViewCellViewModel.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 06/02/2023.
//

import Foundation
import UIKit

final class RMCharacterCollectionViewCellViewModel{
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
        return characterStatus.rawValue
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>)->Void){
        //Todo: abstract to image manager 
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil  else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }

    task.resume()
}
}
