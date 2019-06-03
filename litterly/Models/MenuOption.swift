//
//  MenuOption.swift
//  litterly
//
//  Created by Joy Paul on 4/22/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

enum MenuOption: Int{
    
    case Meetups
    case Profile
    case Logout
    case Settings
    
    var image: UIImage{
        switch self {
        case .Meetups: return UIImage(named: "calendar") ?? UIImage()
        case .Profile: return UIImage(named: "profile") ?? UIImage()
        case .Logout: return UIImage(named: "logout") ?? UIImage()
        case .Settings: return UIImage(named: "menu") ?? UIImage()
        }
    }
}
