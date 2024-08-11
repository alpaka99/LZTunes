//
//  SearchTableViewCell.swift
//  LZTunes
//
//  Created by user on 8/11/24.
//

import UIKit

import SnapKit

final class SearchTableViewCell: BaseTableViewCell {
    let thumbnailImage = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    let musicNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(musicNameLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        thumbnailImage.snp.makeConstraints { img in
//            img.verticalEdges.equalTo(self)
//                .inset(8)
            img.leading.equalTo(self.snp.leading)
                .offset(8)
            img.size.equalTo(44)
            img.verticalEdges.equalTo(self)
                .inset(8)
        }
        
        musicNameLabel.snp.makeConstraints { label in
            label.leading.equalTo(thumbnailImage.snp.trailing)
                .offset(8)
            label.trailing.equalTo(self)
            label.centerY.equalTo(thumbnailImage.snp.centerY)
        }
    }
}
