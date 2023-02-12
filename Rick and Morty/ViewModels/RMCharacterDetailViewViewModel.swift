//
//  RMCharacterDetailViewViewModel.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 09/02/2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter){
        self.character = character
    }
    
    private var requestUrl: URL?{
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
        
    }
    
//    public func fetchCharacterData(){
//        guard let url = requestUrl,
//            let request = RMRequest(url: url) else{
//            return
//        }
//        RMService.shared.execute(request,
//                                 expecting: RMCharacter.self) { result in
//            switch result{
//            case .success(let success):
//                print(String(describing: success))
//            case .failure(let failure):
//                print(String(describing: failure))
//            }
//        }
//    }
}
