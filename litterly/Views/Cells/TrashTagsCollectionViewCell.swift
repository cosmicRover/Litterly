//
//  TrashTagsCollectionViewCell.swift
//  litterly
//
//  Created by Joyce Huang on 6/27/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class TrashTagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var trashTag: TrashTags! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let trashTag = trashTag {
            featuredImageView.image = trashTag.featuredImage
            titleLabel.text = trashTag.title
            descriptionLabel.text = trashTag.description
            overlayView.backgroundColor = trashTag.color
        } else {
            featuredImageView.image = nil
            titleLabel.text = nil
            descriptionLabel.text = nil
            overlayView.backgroundColor = nil
        }
        
        featuredImageView.layer.cornerRadius = 10.0
        featuredImageView.layer.masksToBounds = true
        overlayView.layer.cornerRadius = 10.0
        overlayView.layer.masksToBounds = true
        overlayView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
