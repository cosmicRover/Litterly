//
//  MeetupsQueryModel.swift
//  litterly
//
//  Created by Joy Paul on 5/22/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation

struct MeetupsQueryModel{
    
    var meetup_address: String
    var meetup_date_time: String
    var type_of_trash: String
    
    var dictionary:[String: Any]{
        return [
            "meetup_address" : meetup_address,
            "meetup_date_time" :  meetup_date_time,
            "type_of_trash" : type_of_trash
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension MeetupsQueryModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        //guard let to make sure we don't run into nil values
        guard let meetup_address = dictionary["meetup_address"] as? String,
        let  meetup_date_time = dictionary["meetup_date_time"] as? String,
        let type_of_trash = dictionary["type_of_trash"] as? String else {return nil}
        //confirmed meetups [confirmed_meetups]
        
        self.init(meetup_address: meetup_address, meetup_date_time: meetup_date_time, type_of_trash: type_of_trash)
    }
}
