//
//  RMChracterStatus.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 03/02/2023.
//

import Foundation
enum RMCharacterStatus: String, Codable{
    case Alive = "Alive"
    case Dead = "Dead"
    case `Unknown` = "unknown"
    
    var text: String {
        switch self {
        case .Alive:
            return rawValue
        case .Dead:
            return rawValue
        case .Unknown:
            return "Unknown"
        }
    }
}
