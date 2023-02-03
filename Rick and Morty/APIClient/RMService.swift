//
//  RMService.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 02/02/2023.
//

import Foundation


/// API service object to get Rick and Morty data
final class RMService {
    /// Shared  singleton instance
    static let shared = RMService()
    
    private init(){}
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - completion: Callback with data or error
    public func execute<T: Codable> (
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<String, Error>) -> Void
     ){
        
    }
}
