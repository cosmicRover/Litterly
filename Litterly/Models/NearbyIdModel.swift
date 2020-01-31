//
//  NearbyIDModel.swift
//  Litterly
//
//  Created by Joy Paul on 7/1/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation


struct NearbyIdModel{
    
    var nearby_id: String
    var nearby_id_lat: Double
    var nearby_id_lon: Double
    var nearby_id_distance: Double
    
    var dictionary:[String: Any]{
        return [
            "nearby_id" : nearby_id,
            "nearby_id_lat" :  nearby_id_lat,
            "nearby_id_lon" : nearby_id_lon,
            "nearby_id_distance" : nearby_id_distance
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension NearbyIdModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        //guard let to make sure we don't run into nil values
        guard let nearby_id = dictionary["nearby_id"] as? String,
            let  nearby_id_lat = dictionary["nearby_id_lat"] as? Double,
            let nearby_id_lon = dictionary["nearby_id_lon"] as? Double,
            let nearby_id_distance = dictionary["nearby_id_distance"] as? Double else {return nil}
        //confirmed meetups [confirmed_meetups]
        
        self.init(nearby_id: nearby_id, nearby_id_lat: nearby_id_lat, nearby_id_lon: nearby_id_lon, nearby_id_distance: nearby_id_distance)
    }
}
