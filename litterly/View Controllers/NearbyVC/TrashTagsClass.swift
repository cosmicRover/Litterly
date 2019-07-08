//
//  TrashTagsClass.swift
//  litterly
//
//  Created by Joyce Huang on 6/27/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class TrashTags {
    
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
    static func createTrashTags() -> [TrashTags]
    {
        return [
            TrashTags(title: "Plastic", description: "55 places", featuredImage: UIImage(named: "bg")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            TrashTags(title: "Organics", description: "10 places", featuredImage: UIImage(named: "NoPath - Copy (13)")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            TrashTags(title: "Compost", description: "20 places", featuredImage: UIImage(named: "bg")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            TrashTags(title: "Biodegradable", description: "25 places", featuredImage: UIImage(named: "NoPath - Copy (13)")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            TrashTags(title: "Metals", description: "5 places", featuredImage: UIImage(named: "bg")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
            TrashTags(title: "Paper", description: "30 places", featuredImage: UIImage(named: "NoPath - Copy (13)")!, color: UIColor(red: 53/255, green: 58/255, blue: 80/255, alpha: 1.0)),
        ]
    }
}
