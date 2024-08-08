//
//  BaseView.swift
//  LZTunes
//
//  Created by user on 8/9/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        configureUI()
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() { }
    func configureUI() { self.backgroundColor = .white }
}