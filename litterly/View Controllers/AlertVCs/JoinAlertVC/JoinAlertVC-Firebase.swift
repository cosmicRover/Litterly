//
//  JoinAlertVC-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 5/20/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension JoinAlertViewController{
    
    //get meetup details
    func meetupDetailsFromFirestore(for meetupId:String){
        
        let ref = sharedValue.db.collection("Meetups").document("\(meetupId)")
        
        ref.getDocument { (document, error) in
            
            //gets selective chunk of the data from the document and passes it to vars for use in
            //the alert VC. confirmed_users is a list of nested objects
            let address = document?.data()!["meetup_address"]
            let meetup_date_time = document?.data()!["meetup_date_time"]
            let confirmed_users = document?.data()!["confirmed_users"] as! [[String:String]]
            let meetup_day = document?.data()!["meetup_day"] as! String
            self.markerLat = document?.data()!["marker_lat"] as! Double
            self.markerLon = document?.data()!["marker_lon"] as! Double
            self.viewingMeetupDay = meetup_day
            
            print("******JOIN ALERT PRE-REQ")
            print(self.viewingMeetupDay)
            print(self.dayMeetupCount)
            
            self.checkDayCount(for: meetup_day as! String, completionHandler: { (count) in
                if let count = count{
                    if count < 10{
                        self.meetupAddress.fadeTransition(0.4)
                        self.meetupAddress.text = "\(address as! String)"
                        
                        self.meetupDateAndTime.fadeTransition(0.4)
                        self.meetupDateAndTime.text = "\(meetup_date_time as! String)"
                        
                        self.confirmedUsers = confirmed_users
                        
                        self.attendingUserCollectionView.reloadData()
                        
                        let isUserOnTheList = self.didUserAlreadyJoin(search: "\(self.sharedValue.currentUserEmail! as String)")
                        
                        isUserOnTheList ? self.changeAlertHeader(with: "You are on the list!") : self.enableJoinButton()
                        
                        print("isUserPresent: \(isUserOnTheList)")
                    }else{
                        self.meetupAddress.fadeTransition(0.4)
                        self.meetupAddress.text = "\(address as! String)"
                        
                        self.meetupDateAndTime.fadeTransition(0.4)
                        self.meetupDateAndTime.text = "\(meetup_date_time as! String)"
                        
                        self.confirmedUsers = confirmed_users
                        
                        self.attendingUserCollectionView.reloadData()
                        
                        let isUserOnTheList = self.didUserAlreadyJoin(search: "\(self.sharedValue.currentUserEmail! as String)")
                        
                        isUserOnTheList ? self.changeAlertHeader(with: "You are on the list!") :
                            self.changeAlertHeader(with: "You are maxed for \(self.viewingMeetupDay as String)")
                    }
                }
            })
        }
        
    }
    
    //*******TODO********
    //*****get the day count before enabling the join button
    //*****modify the meetup data model to contain a day field
    func checkDayCount(for day:String, completionHandler: @escaping (Int?) -> Void){
        let docId = sharedValue.currentUserEmail
        let geofenceDataRef = sharedValue.db.collection("GeofenceData").document("\(docId as! String)")
        
        geofenceDataRef.getDocument { (snapshot, error) in
            if let err = error{
                print("error getting day count -> ", err.localizedDescription)
                return
            }
            
            if let data = snapshot?.data(){
                let day_count = data["\(day as String)_count"]
                self.dayMeetupCount = day_count as? Int
                completionHandler(day_count as? Int)
            }
            
        }
    }
    
    //appends user_id to confirmed_users array
    func updateConfirmedUsersArrayAndUsersIdArray(for id:String, with userId:String, and picUrl:String){
        let batch = Firestore.firestore().batch()
        let meetupRef = sharedValue.db.collection("Meetups").document("\(id)")
        let geofenceDocRef = sharedValue.db.collection("GeofenceData").document("\(userId)")
        
        batch.updateData([
            "confirmed_users" : FieldValue.arrayUnion([["user_id" : "\(userId)", "user_pic_url" : "\(picUrl)"]]),
            "confirmed_users_ids": FieldValue.arrayUnion(["\(userId)"])
            ], forDocument: meetupRef)
        
        batch.updateData([
            "\(self.viewingMeetupDay as String)" : FieldValue.arrayUnion([["lat" : markerLat, "lon" : markerLon]])
            ], forDocument: geofenceDocRef)
        
        batch.updateData(
            ["\(self.viewingMeetupDay as String)_count" : self.dayMeetupCount + 1],
            forDocument: geofenceDocRef)
        
        batch.commit { (err) in
            if let err = err{
                print(err.localizedDescription)
                //show error  alert
            } else{
                print("update commited successfully")
                self.showSuccessAlert()
            }
        }
    }
    
    //searches the confirmed users array for current user id
    func didUserAlreadyJoin(search id:String) -> Bool{
        for users in self.confirmedUsers{
            if let id = users["user_id"]{
                if id == "\(sharedValue.currentUserEmail! as String)"{
                    return true
                }
            }
        }
        return false
    }
    
    func enableJoinButton(){
        joinButton.isEnabled = true
    }
    
    func changeAlertHeader(with text:String){
        headerTitle.text = "\(text)"
    }
}
