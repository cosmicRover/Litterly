//
//  GeofenceDataModel.swift
//  litterly
//
//  Created by Joy Paul on 8/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation

struct GeofenceDataModel{
    
    var user_id:String
    var device_token:String
    var monday:[[String:String]]
    var tuesday:[[String:String]]
    var wednesday:[[String:String]]
    var thursday:[[String:String]]
    var friday:[[String:String]]
    var saturday:[[String:String]]
    var sunday:[[String:String]]
    var monday_count:Int
    var tuesday_count:Int
    var wednesday_count:Int
    var thursday_count:Int
    var friday_count:Int
    var saturday_count:Int
    var sunday_count:Int
    
    
    var dictionary:[String: Any]{
        return [
            "user_id": user_id,
            "device_token": device_token,
            "monday": monday,
            "tuesday": thursday,
            "wednesday": wednesday,
            "thursday": thursday,
            "friday": friday,
            "saturday": saturday,
            "sunday": sunday,
            "monday_count": monday_count,
            "tuesday_count": tuesday_count,
            "wednesday_count": wednesday_count,
            "thursday_count": thursday_count,
            "friday_count": friday_count,
            "saturday_count": saturday_count,
            "sunday_count": sunday_count
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension GeofenceDataModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        //guard let to make sure we don't run into nil values
        guard let user_id = dictionary["user_id"] as? String,
        let device_token = dictionary["device_token"] as? String,
        let monday = dictionary["monday"] as? [[String:String]],
        let tuesday = dictionary["tuesday"] as? [[String:String]],
        let wednesday = dictionary["wednesday"] as? [[String:String]],
        let thursday = dictionary["thursday"] as? [[String:String]],
        let friday = dictionary["friday"] as? [[String:String]],
        let saturday = dictionary["saturday"] as? [[String:String]],
        let sunday = dictionary["sunday"] as? [[String:String]],
        let monday_count = dictionary["monday_count"] as? Int,
        let tuesday_count = dictionary["tuesday_count"] as? Int,
        let wednesday_count = dictionary["wednesday_count"] as? Int,
        let thursday_count = dictionary["thursday_count"] as? Int,
        let friday_count = dictionary["friday_count"] as? Int,
        let saturday_count = dictionary["saturday_count"] as? Int,
            let sunday_count = dictionary["sunday_count"] as? Int else {return nil}
        
        self.init(user_id: user_id, device_token: device_token, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday, monday_count: monday_count, tuesday_count: tuesday_count, wednesday_count: wednesday_count, thursday_count: thursday_count, friday_count: friday_count, saturday_count: saturday_count, sunday_count: sunday_count)
    }
}
