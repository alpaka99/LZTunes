//
//  SearchViewController.swift
//  LZTunes
//
//  Created by user on 8/9/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController<SearchView, SearchViewModel> {
    
    let disposeBag = DisposeBag()

    let searchBar = UISearchBar()
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "request", style: .plain, target: nil, action: nil)
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
    }
    
    override func configureBind() {
        super.configureBind()
        
        searchBar.rx.searchButtonClicked
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(to: viewModel.store.searchActionRequested)
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(to: viewModel.store.searchActionRequested)
            .disposed(by: disposeBag)
        
        viewModel.store.searchResult
            .bind(to: baseView.tableView.rx.items(cellIdentifier: "test", cellType: UITableViewCell.self)) { row, item, cell in
                cell.textLabel?.text = item.artistViewUrl
            }
            .disposed(by: disposeBag)
            
    }
}

