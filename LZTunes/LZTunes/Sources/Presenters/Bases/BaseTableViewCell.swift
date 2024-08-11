//
//  BaseTableViewCell.swift
//  LZTunes
//
//  Created by user on 8/11/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell, Reusable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureUI() { }
}

protocol Reusable { }

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
