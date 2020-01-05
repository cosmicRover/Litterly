//
//  Colors.swift
//  Litterly
//
//  Created by Joy Paul on 12/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static let litterlyWhite = UIColor(hex: 0xFFFFFF)
    static let litterlyGreen = UIColor(hex: 0x2ECC71)
    
    //MARK: Hex to UIColor conversion init
    convenience init(hex: Int, alpha: CGFloat = 1.0){
        self.init(
            red: CGFloat((hex >> 16) & 0xFF),
            green: CGFloat((hex >> 8) & 0xFF),
            blue: CGFloat(hex & 0xFF),
            alpha: alpha
        )
    }
    
}
