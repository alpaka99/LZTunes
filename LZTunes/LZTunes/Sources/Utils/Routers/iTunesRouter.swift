//
//  iTunesRouter.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//

import Foundation
enum iTunesRouter: Router {
    case search(searchText: String)
    
    var baseURL: String {
        switch self {
        case .search:
            return "https://itunes.apple.com"
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .search:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(searchText: let searchText):
            let queryItems = [
                URLQueryItem(name: "term", value: searchText)
            ]
            
            return queryItems
        }
    }
    
    
    func build() -> URLRequest? {
        let url = self.baseURL
        
        var components = URLComponents(string: url)
        components?.path = self.path
        components?.queryItems = self.queryItems
        
        
        if let composedURL = components?.url {
            let request = URLRequest(url: composedURL)
            return request
        }
        
        return nil
    }
}


protocol Router {
    func build() -> URLRequest?
}
