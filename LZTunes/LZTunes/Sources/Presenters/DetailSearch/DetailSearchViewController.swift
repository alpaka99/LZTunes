//
//  DetailSearchViewController.swift
//  LZTunes
//
//  Created by user on 8/12/24.
//

import UIKit

import RxCocoa
import RxSwift

final class DetailSearchViewController: BaseViewController<DetailSearchView, DetailSearchViewModel> {
    
    let disposeBag = DisposeBag()
    
    override func configureBind() {
        super.configureBind()
        
        viewModel.store.detailViewURL
            .bind(with: self) { owner, urlString in
                if let url = URL(string: urlString) {
                    let request = URLRequest(url: url)
                    owner.baseView.webView.load(request)
                }
            }
            .disposed(by: disposeBag)
    }
}
