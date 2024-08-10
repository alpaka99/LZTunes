//
//  iTunesResponse.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//

struct iTunesResponse: Decodable {
    let resultCount: Int
    let results: [iTunesResult]
}

struct iTunesResult: Decodable {
    let kind: String?
    let artistViewUrl: String?
}
