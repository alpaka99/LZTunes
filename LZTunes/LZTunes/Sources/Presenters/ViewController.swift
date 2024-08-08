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
    
}

final class ViewController: BaseViewController<ViewControllerView, ViewControllerViewModel> {

    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "BaseView Implemented"
    }


}

