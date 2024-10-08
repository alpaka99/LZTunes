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
import Toast

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
        baseView.tableView.delegate = self
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
                    let detailSearchViewModel = DetailSearchViewModel()
                    detailSearchViewModel.store.detailViewURL.onNext(collectionViewUrl)
                    
                    let detailSearchViewController = DetailSearchViewController(baseView: DetailSearchView(), viewModel: detailSearchViewModel)
                    
                    owner.navigationController?.pushViewController(detailSearchViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        
        viewModel.store.toastMessage
            .debug()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.baseView.makeToast(message, duration: 3.0 ,title: "쵸비상!", image: UIImage(named: "toast"))
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
