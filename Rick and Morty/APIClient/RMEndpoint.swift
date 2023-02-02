//
//  RMEndpoint.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 02/02/2023.
//

import Foundation

/// Represents Unique API Endpoint
@frozen enum RMEndpoint: String {
    ///Endpoint  to get character info
    case character
    ///Endpoint  to get Location info
    case location
    ///Endpoint  to get Episode info
    case episode
} 
