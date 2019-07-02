//
//  MeetUpsClass.swift
//  litterly
//
//  Created by Joyce Huang on 6/27/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class MeetUps {
    
    var title = ""
    var description = ""
    var featuredImage: UIImage!
    var color: UIColor
    
    init(title: String, description: String, featuredImage: UIImage, color: UIColor)
    {
        self.title = title
        self.description = description
        self.featuredImage = featuredImage
        self.color = color
    }
    
    
    // dummy data
    static func createMeetUps() -> [MeetUps]
    {
        return [
            MeetUps(title: "Pho Montreal", description: "2 mi, 4 stars", featuredImage: UIImage(named: "NoPath")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            MeetUps(title: "Rigolati", description: "2 mi, 5 stars", featuredImage: UIImage(named: "NoPath - Copy (7)")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            MeetUps(title: "Toronto", description: "5 mi, 4 stars", featuredImage: UIImage(named: "NoPath")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            MeetUps(title: "Oregon", description: "7 mi, 3 stars", featuredImage: UIImage(named: "NoPath - Copy (7)")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            MeetUps(title: "Lousiana", description: ".5 mi, 2 stars", featuredImage: UIImage(named: "NoPath")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            MeetUps(title: "West Village", description: "10 mi, 5 stars", featuredImage: UIImage(named: "NoPath - Copy (7)")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
        ]
    }
}
