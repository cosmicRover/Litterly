//
//  MeetupDataModel.swift
//  Litterly
//
//  Created by Joy Paul on 5/13/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation


struct MeetupDataModel{
    
    var marker_lat: Double
    var marker_lon: Double
    var meetup_address: String
    //var neighborhood: String
    var meetup_date_time: String
    var meetup_id: String
    var parent_marker_id: String
    var type_of_trash: String
    var author_id: String
    var author_display_name: String
    var confirmed_users:[[String:String]]
    var confirmed_users_ids:[String]
    var meetup_timezone: String
    var UTC_meetup_time_and_expiration_time: Double
    var meetup_day:String
    
    
    var dictionary:[String: Any]{
        return [
            "marker_lat" : marker_lat,
            "marker_lon": marker_lon,
            "meetup_address": meetup_address,
            "meetup_date_time": meetup_date_time,
            "meetup_id": meetup_id,
            "parent_marker_id" : parent_marker_id,
            "type_of_trash": type_of_trash,
            "author_id": author_id,
            "author_display_name": author_display_name,
            "confirmed_users": confirmed_users,
            "confirmed_users_ids": confirmed_users_ids,
            "meetup_timezone": meetup_timezone,
            "UTC_meetup_time_and_expiration_time" : UTC_meetup_time_and_expiration_time,
            "meetup_day": meetup_day
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension MeetupDataModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        //guard let to make sure we don't run into nil values
        guard let marker_lat = dictionary["marker_lat"] as? Double,
            let marker_lon = dictionary["marker_lon"] as? Double,
            let meetup_address = dictionary["meetup_address"] as? String,
            let meetup_date_time = dictionary["meetup_date_time"] as? String,
            let parent_marker_id = dictionary["parent_marker_id"] as? String,
            let type_of_trash = dictionary["type_of_trash"] as? String,
            let meetup_id = dictionary["meetup_id"] as? String,
            let author_id = dictionary["author_id"] as? String,
            let author_display_name = dictionary["author_display_name"] as? String,
            let confirmed_users = dictionary["confirmed_users"] as? [[String:String]],
            let meetup_day = dictionary["meetup_day"] as? String,
            let meetup_timezone = dictionary["meetup_timezone"] as? String,
            let UTC_meetup_time_and_expiration_time = dictionary["UTC_meetup_time_and_expiration_time"] as? Double,
            let confirmed_users_ids = dictionary["confirmed_users_ids"] as? [String] else {return nil}
        
        self.init(marker_lat: marker_lat, marker_lon: marker_lon, meetup_address: meetup_address, meetup_date_time: meetup_date_time, meetup_id: meetup_id, parent_marker_id: parent_marker_id, type_of_trash: type_of_trash, author_id: author_id, author_display_name: author_display_name, confirmed_users: confirmed_users, confirmed_users_ids: confirmed_users_ids, meetup_timezone: meetup_timezone, UTC_meetup_time_and_expiration_time:UTC_meetup_time_and_expiration_time, meetup_day: meetup_day)
    }
}
