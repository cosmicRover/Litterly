//
//  ProfileVC-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 5/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

extension ProfileViewController{
    
    //fetches the user tagged trash markers
    //use this for the tableView
    func fetchUserTaggedTrash(completion: @escaping (Int?) -> ()){
        let currentUserId = Auth.auth().currentUser?.email
        let trashTagCountQuery = db.collection("TaggedTrash").whereField("author", isEqualTo: currentUserId!)
        
        trashTagCountQuery.getDocuments(){
            QuerySnapshot, Error in
            
            guard let snapShot = QuerySnapshot else {return}
            
            snapShot.documents.forEach{
                data in
                
                self.userTaggedTrash.append(TrashDataModel(dictionary: data.data())!)
                
            }
            
            completion(self.userTaggedTrash.count as Int)
            self.tableView.reloadData()
            //print(self.userTaggedTrash.count as Int)
        }
        
        
    }
    
    func fetchUserCreatedMeetup(completion: @escaping (Int?) -> ()){
        let currentUserId = Auth.auth().currentUser?.email
        let trashTagCountQuery = db.collection("Meetups").whereField("author_id", isEqualTo: "\(currentUserId! as String)" )
        
        trashTagCountQuery.getDocuments(){
            QuerySnapshot, Error in
            
            guard let snapShot = QuerySnapshot else {return}
            
            snapShot.documents.forEach{
                data in
                
                //print(data.data())
                
                let address = data.data()["meetup_address"]
                let meetup_date_time = data.data()["meetup_date_time"]
                let type_of_trash = data.data()["type_of_trash"]
                
                let dataToAppend = MeetupsQueryModel(meetup_address: address as! String, meetup_date_time: meetup_date_time as! String, type_of_trash: type_of_trash as! String)
                
                self.userCreatedMeetups.append(dataToAppend)
                
            }
            
            completion(self.userCreatedMeetups.count)
            print(self.userCreatedMeetups)
            self.tableView.reloadData()
        }
        
    }
    
    //fetches the basic user info from firestore
    func fetchUserBasicInfo(completion: @escaping (String?, String?) -> ()){
        let currentUserId = Auth.auth().currentUser?.email
        let trashTagCountQuery = db.collection("Users").whereField("user_id", isEqualTo: currentUserId!)
        
        trashTagCountQuery.getDocuments(){
            QuerySnapshot, Error in
            
            //self.userTaggedTrash = (QuerySnapshot!.documents.compactMap({TrashDataModel(dictionary: $0.data())}))
            
            guard let snapShot = QuerySnapshot else {return}
            
            snapShot.documents.forEach{
                data in
                
                self.userBasicInfo = UserDataModel(dictionary: data.data())
                
            }
            
            completion(self.userBasicInfo.user_name, self.userBasicInfo.neighborhood)
            //print(self.userTaggedTrash.count as Int)
        }
        
    }
    
}
