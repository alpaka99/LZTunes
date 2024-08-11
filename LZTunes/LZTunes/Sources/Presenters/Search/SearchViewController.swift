//
//  SearchViewController.swift
//  LZTunes
//
//  Created by user on 8/9/24.
//

import UIKit

import Kingfisher
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
        
        baseView.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        baseView.tableView.rowHeight = 50
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
            .bind(to: baseView.tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { row, item, cell in
                cell.thumbnailImage.kf.setImage(with: URL(string:item.artworkUrl100))
                cell.musicNameLabel.text = item.trackName
            }
            .disposed(by: disposeBag)
        
        
        baseView.tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                owner.baseView.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        baseView.tableView.rx.modelSelected(iTunesResult.self)
            .bind(with: self) { owner, data in
                owner.viewModel.store.selectedData.onNext(data)
            }
            .disposed(by: disposeBag)
        
        
        viewModel.store.detailViewURL
            .bind(with: self) { owner, data in
                if let collectionViewUrl = data {
                    print(collectionViewUrl)

                }
            }
            .disposed(by: disposeBag)
    }
}

