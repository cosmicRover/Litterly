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
    
    //append to the confirmedUsers array
    func appendToConfirmedUsers(for meetupId:String, user_id:String, user_pic_url:String){
        //get parent's reference
        let ref = sharedValue.db.collection("Meetups").document("\(meetupId)")
        
        //update the objects array using arrayUnion
        ref.updateData([
            "confirmed_users": FieldValue.arrayUnion([["user_id" : "\(user_id as String)", "user_pic_url" : "\(user_pic_url as String)"]])
            ])
    }
    
    //get meetup details
    func meetupDetailsFromFirestore(for meetupId:String){
        
        let ref = sharedValue.db.collection("Meetups").document("\(meetupId)")
        
        ref.getDocument { (document, error) in
            
            let address = document?.data()!["meetup_address"]
            let meetup_date_time = document?.data()!["meetup_date_time"]
            let confirmed_users = document?.data()!["confirmed_users"] as! [[String:String]]
            
            self.meetupAddress.fadeTransition(0.4)
            self.meetupAddress.text = address as! String
            
            self.meetupDateAndTime.fadeTransition(0.4)
            self.meetupDateAndTime.text = meetup_date_time as! String
            
            self.confirmedUsers = confirmed_users
            
            self.attendingUserCollectionView.reloadData()
            
            let isUserOnTheList = self.didUserAlreadyJoin(search: "\(self.sharedValue.currentUserEmail! as String)")
            
            isUserOnTheList ? self.changeAlertHeader() : self.enableJoinButton()
            
            print("isUserPresent: \(isUserOnTheList)")
        }
        
    }
    
    //appends user_id to confirmed_users array
    func updateConfirmedUsersArray(for id:String, with userId:String, and picUrl:String){
        
        let meetupRef = sharedValue.db.collection("Meetups").document("\(id)")
        
        meetupRef.updateData([
            "confirmed_users" : FieldValue.arrayUnion([["user_id" : "\(userId)", "user_pic_url" : "\(picUrl)"]])
            ])
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
    
    func changeAlertHeader(){
        headerTitle.text = "You are on the list!"
    }
}
