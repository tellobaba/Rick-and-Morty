//
//  RMRequest.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 02/02/2023.
//

import Foundation

///Object that represents a single API call 
final class RMRequest{
    ///api constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    /// endpoints
    private let endpoint: RMEndpoint
    ///components for api if there are any
    private let pathComponents: [String]
    /// query argument for api if there are any
    private let queryParameters: [URLQueryItem]
    
    ///Constructed url for the api request in string format
    
    private var urlString: String{
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty{
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty{
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        return string
    }
    
    ///computed & constructed api url
    public var url: URL? {
        return URL(string: urlString)
    }
    /// http method
    public let httpMethod = "GET"
    
    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ){
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL){
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "", with: "")
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        }  else if trimmed.contains("?"){
            let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "", with: "")
            if trimmed.contains("/"){
                let components = trimmed.components(separatedBy: "?")
                if !components.isEmpty, components.count >= 2 {
                    let endpointString = components[0]
                     let queryItemsString = components[1]
                    let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                        guard $0.contains("=") else{
                            return nil
                        }
                        let parts = $0.components(separatedBy: "=")
                        return URLQueryItem(
                            name: parts[0],
                            value: parts[1])
                    })
                    
                    if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                        self.init(endpoint: rmEndpoint, queryParameters: queryItems  )
                        return
                    }
                }
            }
        }
            return nil
        }
    }



extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
}

