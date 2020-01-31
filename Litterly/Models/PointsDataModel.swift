//
//  PointsDataModel.swift
//  Litterly
//
//  Created by Joy Paul on 10/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation

struct PointsDataModel{
    
    var cumulative_points: Double
    var total_points: Double
    
    var dictionary:[String: Any]{
        return [
            "cumulative_points" : cumulative_points,
            "total_points" : total_points
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension PointsDataModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        guard let cumulative_points = dictionary["cumulative_points"] as? Double,
            let total_points = dictionary["total_points"] as? Double else {return nil}
        
        self.init(cumulative_points: cumulative_points, total_points: total_points)
    }}
