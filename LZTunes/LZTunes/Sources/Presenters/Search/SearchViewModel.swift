//
//  SearchViewModel.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//

import RxCocoa
import RxSwift

final class SearchViewModel: ViewModel {
    let disposeBag = DisposeBag()
    
    struct Input: Inputable {
        var searchActionRequested: PublishSubject<String> = PublishSubject()
    }
    
    struct Output: Outputable {
        var searchResult: PublishSubject<[iTunesResult]> = PublishSubject()
    }
    
    init() {
        bind()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    let repository = iTunesRepository()
    
    func bind() {
        store.searchActionRequested
            .bind(to: repository.searchText)
            .disposed(by: disposeBag)
        
        repository.searchResult
            .debug()
            .bind(to: store.searchResult)
            .disposed(by: disposeBag)
    }
}
