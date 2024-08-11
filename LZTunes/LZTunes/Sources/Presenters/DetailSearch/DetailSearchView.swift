//
//  DetailSearchView.swift
//  LZTunes
//
//  Created by user on 8/12/24.
//

import UIKit
import WebKit

import SnapKit

final class DetailSearchView: BaseView {
    let webView = {
        let view = WKWebView()
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(webView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        webView.snp.makeConstraints { view in
            view.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
