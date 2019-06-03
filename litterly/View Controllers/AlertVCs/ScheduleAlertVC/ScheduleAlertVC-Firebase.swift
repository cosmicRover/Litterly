//
//  AlertVC-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 5/13/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension ScheduleAlertViewController{
    
    //add to the meetups collections with a specefied id
    func createAMeetup(with dictionary: [String:Any], for id:String){
        
        sharedValue.db.collection("Meetups").document("\(id)").setData(dictionary) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("meetup created successfully!")
            }
            
        }
        
    }
    
    //update meetup property of a marker with a specifice id
    func updateMeetupProperty(for id:String, with value:Bool){
        sharedValue.db.collection("TaggedTrash").document("\(id)").updateData([
            "is_meetup_scheduled" : true
        ]) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
