//
//  NetworkManager.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//

import Foundation

final class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    override private init() { }
    
    var buffer: Data?
    
    func requestCall() {
        let urlRequest = iTunesRouter
            .search(searchText: "apple")
            .build()
        if let urlRequest = urlRequest {
            let session = URLSession(
                configuration: .default,
                delegate: self,
                delegateQueue: .current
            )
            
            let dataTask = session.dataTask(with: urlRequest)
            dataTask.resume()
        }
    }
}

extension NetworkManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                print("allowed")
                buffer = Data()
                return .allow
            } else {
                print("not allowed")
                buffer = nil
                return .cancel
            }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        print("downloading...")
        buffer?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        guard error == nil else {
            print("URLSession Data Task Error: \(error)")
            return
        }
        
        
        if let buffer = buffer {
            let decodedData = try! JSONDecoder().decode(iTunesResponse.self, from: buffer)
            print("decoded data: \(decodedData)")
        } else {
            print("nil buffer")
        }
    }
    
}

struct iTunesResponse: Decodable {
    let resultCount: Int
    let results: [iTunesResult]
}

struct iTunesResult: Decodable {
    let kind: String?
    let artistViewUrl: String?
}
