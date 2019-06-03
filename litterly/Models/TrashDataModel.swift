//
//  TrashDataModel.swift
//  litterly
//
//  Created by Joy Paul on 4/19/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

//this is a struct for our trash data model
//we store the properties of trash data model that we send to/ receive from firestore
//we use protocol to effortlessly sticth the values we pass to this model into a dictionary

import Foundation

struct TrashDataModel{
    
    var id: String
    var author: String
    var lat: Double
    var lon: Double
    var trash_type: String
    var street_address: String
    var is_meetup_scheduled: Bool
    
    var dictionary:[String: Any]{
        return [
            "id" : id,
            "lat" : lat,
            "lon" : lon,
            "author" : author,
            "trash_type" : trash_type,
            "street_address" : street_address,
            "is_meetup_scheduled" : is_meetup_scheduled
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension TrashDataModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        //guard let to make sure we don't run into nil values
        guard let id = dictionary["id"] as? String,
            let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double,
            let author = dictionary["author"] as? String,
            let trash_type = dictionary["trash_type"] as? String,
            let street_address = dictionary["street_address"] as? String,
            let is_meetup_scheduled = dictionary["is_meetup_scheduled"] as? Bool else {return nil}
        
        
        self.init(id: id, author: author, lat: lat, lon: lon, trash_type: trash_type, street_address: street_address, is_meetup_scheduled: is_meetup_scheduled)
    }
}
