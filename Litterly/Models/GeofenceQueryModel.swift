//
//  GeofenceQueryModel.swift
//  Litterly
//
//  Created by Joy Paul on 8/15/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation

struct GeofenceQueryModel{
    
    var lat: Double
    var lon: Double
    
    var dictionary:[String: Any]{
        return [
            "lat" : lat,
            "lon" :  lon
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension GeofenceQueryModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        //guard let to make sure we don't run into nil values
        guard let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double else {return nil}
        //confirmed meetups [confirmed_meetups]
        
        self.init(lat: lat, lon: lon)
    }
}
