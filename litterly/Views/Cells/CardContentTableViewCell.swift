//
//  EmbeddedTableViewCell.swift
//  litterly
//
//  Created by Joyce Huang on 4/25/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class CardContentTableViewCell: UITableViewCell {
    
    //just holding the labels here, and the action for the button
    @IBOutlet weak var backBarView: UIView!
    @IBOutlet weak var iconParentView: UIView!
    @IBOutlet weak var iconImageButton: UIButton!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBAction func iconButtonOnTap(_ sender: UIButton) {
        
        print("You pressed on the icon, well done!")
    }
    
 
}


