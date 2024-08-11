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
    let trackName: String
    let artworkUrl30: String
    let artworkUrl100: String
    let artistViewUrl: String
    let collectionViewUrl: String?
}
