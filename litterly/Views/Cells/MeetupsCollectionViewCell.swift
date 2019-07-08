//
//  MeetupsCollectionViewCell.swift
//  litterly
//
//  Created by Joyce Huang on 7/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class MeetupsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var meetup: MeetUps! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let meetup = meetup {
            featuredImageView.image = meetup.featuredImage
            titleLabel.text = meetup.title
            descriptionLabel.text = meetup.description
            overlayView.backgroundColor = meetup.color
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
