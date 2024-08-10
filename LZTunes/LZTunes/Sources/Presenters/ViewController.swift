//
//  ViewController.swift
//  LZTunes
//
//  Created by user on 8/9/24.
//

import UIKit

final class ViewControllerView: BaseView {
    
}

final class ViewControllerViewModel: ViewModel {
    struct Input: Inputable {

    }
    
    struct Output: Outputable {
        var navigationTitle = "Title From ViewModel"
        var backgroundColor = UIColor.systemBlue
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    func testFunction() {
//        store.reduce(store.backgroundColor, into: .systemIndigo)
        store.reduce(store.navigationTitle, into: "Changed Title")
        let result: String = store.navigationTitle
        print(result)
    }
}

final class ViewController: BaseViewController<ViewControllerView, ViewControllerViewModel> {

    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = viewModel.store.navigationTitle
        view.backgroundColor = viewModel.store.backgroundColor
        
//        iTunesRouter.search(searchText: "bts").build()
        NetworkManager.shared.requestCall()
    }
}

