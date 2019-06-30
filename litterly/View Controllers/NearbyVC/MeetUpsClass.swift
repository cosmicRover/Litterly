//
//  MeetUpsClass.swift
//  litterly
//
//  Created by Joyce Huang on 6/27/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class MeetUps {
    // MARK: - Public API
    var title = ""
    var description = ""
    var featuredImage: UIImage!
    
    init(title: String, description: String, featuredImage: UIImage!)
    {
        self.title = title
        self.description = description
        self.featuredImage = featuredImage
    }
    
    // MARK: - Private
    // dummy data
    static func createMeetUps() -> [MeetUps]
    {
        return [
            MeetUps(title: "Pho Montreal", description: "2 mi, 4 stars", featuredImage: UIImage(named: "NoPath")!),
            MeetUps(title: "Rigolati", description: "2 mi, 5 stars", featuredImage: UIImage(named: "NoPath - Copy (7)")!),
            MeetUps(title: "Toronto", description: "5 mi, 4 stars", featuredImage: UIImage(named: "NoPath")!),
            MeetUps(title: "Oregon", description: "7 mi, 3 stars", featuredImage: UIImage(named: "NoPath - Copy (7)")!),
            MeetUps(title: "Lousiana", description: ".5 mi, 2 stars", featuredImage: UIImage(named: "NoPath")!),
            MeetUps(title: "West Village", description: "10 mi, 5 stars", featuredImage: UIImage(named: "NoPath - Copy (7)")!),
        ]
    }
}
