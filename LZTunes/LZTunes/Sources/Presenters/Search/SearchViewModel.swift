//
//  SearchViewModel.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//

import RxCocoa
import RxSwift

final class SearchViewModel: RxViewModel {
    
    struct Input: Inputable {
        var searchActionRequested: PublishSubject<String> = PublishSubject()
        var selectedData: PublishSubject<iTunesResult> = PublishSubject()
    }
    
    struct Output: Outputable {
        var searchResult: PublishRelay<[iTunesResult]> = PublishRelay()
        var detailViewURL: PublishRelay<String?> = PublishRelay()
        var toastMessage = PublishSubject<String>()
    }
    
    
    var store = ViewStore(input: Input(), output: Output())
    
    let repository = iTunesRepository()
    
    override func configureBind() {
        store.searchActionRequested
            .bind(to: repository.searchText)
            .disposed(by: disposeBag)
        
        repository.searchResult
            .debug()
            .bind(to: store.searchResult)
            .disposed(by: disposeBag)
        
        store.selectedData
            .map { $0.collectionViewUrl }
            .bind(to: store.detailViewURL)
            .disposed(by: disposeBag)
        
        repository.toastMessage
            .bind(to: store.toastMessage)
            .disposed(by: disposeBag)
    }
}
