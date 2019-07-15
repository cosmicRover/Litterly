//
//  TrashTagsCollectionViewCell.swift
//  litterly
//
//  Created by Joy Paul on 7/10/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class TrashTagsCollectionViewCell: UICollectionViewCell {
    
    //the deque identifier
    static var reuseIdentifier: String = "TrashTagsCollectionViewCell"
    
    //the components of the cell
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textWhite
        label.font = UIFont(name: "MarkerFelt-Thin", size: 16)
        label.text = "Title Text"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightText
        label.font = UIFont(name: "MarkerFelt-Thin", size: 14)
        label.text = "Subtitle Text"
        return label
    }()
    
    //init the constraints here
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
        
        self.overlayView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: self.overlayView.topAnchor, constant: 14.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.overlayView.leftAnchor, constant: 16.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.overlayView.rightAnchor, constant: 16.0).isActive = true
        
        self.overlayView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 0.0).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: self.overlayView.leftAnchor, constant: 16.0).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.overlayView.rightAnchor, constant: 16.0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
