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
    let disposeBag = DisposeBag()
    
    var searchText: PublishSubject<String> = PublishSubject()
    
    var searchResult: PublishSubject<[iTunesResult]> = PublishSubject()
    
    init() {
        bind()
    }
    
    func bind() {
        searchText
            .map {
                iTunesRouter.search(searchText: $0)
            }
            .debug()
//            .bind(to: NetworkManager.shared.router)
            .flatMap {
                NetworkManager.shared.requestCallWithSingle(router: $0)
                    .catch { error in // .failure를 통한 error는 여기서 걸러냄
                        return Single<Data>.never()
                    }
            }
            .bind(with: self, onNext: { owner, data in
                let decodedData = try? JSONDecoder().decode(iTunesResponse.self, from: data)
                if let decodedData = decodedData {
                    owner.searchResult.onNext(decodedData.results)
                }
            })
            .disposed(by: disposeBag)

        
//        NetworkManager.shared.completeStatus
//            .bind(with: self) { owner, completeStatus in
//                switch completeStatus {
//                case .complete(let data):
//                    let decodedData = try? JSONDecoder().decode(iTunesResponse.self, from: data)
//                    if let decodedData = decodedData {
//                        owner.searchResult.onNext(decodedData.results)
//                    }
//                case .error(let error):
//                    print("Error", error)
//                }
//            }
//            .disposed(by: disposeBag)
    }
}
