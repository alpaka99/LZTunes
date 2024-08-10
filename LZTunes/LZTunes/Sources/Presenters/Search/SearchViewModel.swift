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
        
    }
    
    init() {
        bind()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    let repository = iTunesRepository()
    
    func bind() {
        store.searchActionRequested
            .debug()
            .bind(with: self) { owner, value in
                owner.repository.calliTunesAPI(of: iTunesRouter.search(searchText: value))
            }
            .disposed(by: disposeBag)
    }
}
