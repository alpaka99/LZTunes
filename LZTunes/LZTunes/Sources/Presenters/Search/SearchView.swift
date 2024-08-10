//
//  SearchView.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//
import UIKit

import SnapKit

final class SearchView: BaseView {
    let tableView = UITableView()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(tableView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        tableView.snp.makeConstraints { tableView in
            tableView.edges.equalTo(self)
        }
    }
}
