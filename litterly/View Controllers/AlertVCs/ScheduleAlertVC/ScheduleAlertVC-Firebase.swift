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
    
    func getMeetupDayCount(for id:String, completionHandler: @escaping (Int?) -> Void){
        let ref = sharedValue.db.collection("GeofenceData").document("\(id)")
        
        ref.getDocument { (snapshot, error) in
            if let err = error{
                print("error getting geofence day! ", err.localizedDescription)
                return
            }
            
            let data = snapshot?.data()
            let day:String = "\(self.scheduleWeekdayText as String)"
            
            completionHandler(data!["\(day)_count"] as? Int)
            
        }
    }
    
    
    //batch write fires up all the data at once and its much more safer
    func batchCreateMeetupAndUpdateMeetupProperty(with dictionary: [String:Any], for meetupId:String, and trashTagId:String, updateTo value:Bool){
        let batch = Firestore.firestore().batch()
        
        let meetupRef = sharedValue.db.collection("Meetups").document("\(meetupId)")
        let taggedTrashRef = sharedValue.db.collection("TaggedTrash").document("\(trashTagId)")
        
        //creating a dictionary with the new value here
        let boolUpdateDict:[String:Bool] = ["is_meetup_scheduled" : value]
        
        batch.setData(dictionary, forDocument: meetupRef)
        batch.updateData(boolUpdateDict, forDocument: taggedTrashRef)
        
        batch.commit { (err) in
            if let err = err{
                print(err.localizedDescription)
                //show error alert
            } else{
                print("successfully comitted")
                self.showSuccessAlert()
            }
        }
        
    }
    
}
