//
//  UserDataModel.swift
//  litterly
//
//  Created by Joy Paul on 4/30/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation

struct UserDataModel{
    
    var user_id: String
    var user_name: String
    var profile_pic_url: String
    var neighborhood: String
    
    var dictionary:[String: Any]{
        return [
            "user_id" : user_id,
            "user_name" : user_name,
            "profile_pic_url" : profile_pic_url,
            "neighborhood" : neighborhood
        ]
    }
}

//extending firestore's DocSerializable type to init a dictionary
extension UserDataModel: DocumentSerializable{
    
    init?(dictionary: [String : Any]) {
        //guard let to make sure we don't run into nil values
        guard let user_id = dictionary["user_id"] as? String,
            let user_name = dictionary["user_name"] as? String,
            let profile_pic_url = dictionary["profile_pic_url"] as? String,
            let neighborhood = dictionary["neighborhood"] as? String else {return nil}
            //confirmed meetups [confirmed_meetups]
        
        self.init(user_id: user_id, user_name: user_name, profile_pic_url: profile_pic_url, neighborhood: neighborhood)
    }
}
