//
//  DetailSearchViewModel.swift
//  LZTunes
//
//  Created by user on 8/12/24.
//

import Foundation

import RxSwift

final class DetailSearchViewModel: RxViewModel {
    struct Input: Inputable {
        var detailViewURL = BehaviorSubject(value: "")
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
}
