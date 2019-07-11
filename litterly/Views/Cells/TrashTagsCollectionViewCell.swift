//
//  TrashTagsCollectionViewCell.swift
//  litterly
//
//  Created by Joy Paul on 7/10/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class TrashTagsCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "TrashTagsCollectionViewCell"
    
    let trashImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
//    let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.text = "Sample text"
//        return label
//    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.addSubview(trashImageView)
        trashImageView.translatesAutoresizingMaskIntoConstraints = false
        
        trashImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        trashImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        trashImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        trashImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
