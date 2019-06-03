//
//  HighlightedButton.swift
//  litterly
//
//  Created by Joy Paul on 4/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

//this class is used to enforce the the custom selected color that is used on the design doc
//the buttons that wish to inherit this functionality must be a child of this class

class SelectedButton: UIButton{
    
    override var isSelected: Bool{
        didSet{
            backgroundColor = isSelected ? .trashOrange : .unselectedGrey
        }
    }
}
