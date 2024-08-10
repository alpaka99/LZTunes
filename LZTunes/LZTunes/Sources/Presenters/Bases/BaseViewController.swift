//
//  BaseViewController.swift
//  LZTunes
//
//  Created by user on 8/9/24.
//

import UIKit

class BaseViewController<T: BaseView, V: ViewModel>: UIViewController {
    let baseView: T
    let viewModel: V
    
    init(baseView: T, viewModel: V) {
        self.baseView = baseView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureBind()
    }
    
    func configureBind() { }
    func configureNavigationItem() { }
}
