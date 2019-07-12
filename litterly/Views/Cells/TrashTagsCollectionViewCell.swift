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
        iv.backgroundColor = UIColor.lightText
        iv.layer.cornerRadius = 12
        iv.contentMode = ContentMode.scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let overlayView:UIView = {
       let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.unselectedGrey
        view.layer.cornerRadius = 12
        return view
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
        trashImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 28).isActive = true
        trashImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        trashImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.contentView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        overlayView.bottomAnchor.constraint(equalTo: trashImageView.bottomAnchor).isActive = true
        overlayView.leftAnchor.constraint(equalTo: trashImageView.leftAnchor).isActive = true
        overlayView.rightAnchor.constraint(equalTo: trashImageView.rightAnchor).isActive = true
        overlayView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
