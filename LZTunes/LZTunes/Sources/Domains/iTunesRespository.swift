//
//  iTunesRespository.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//

import Foundation

import RxCocoa
import RxSwift

final class iTunesRepository {
    
    func calliTunesAPI(of router: Router) {
        NetworkManager.shared.requestCall(router: router)
    }
}
