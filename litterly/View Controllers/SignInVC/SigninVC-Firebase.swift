//
//  SigninVC-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 5/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

extension SigninViewController{
    
    //creates a user on firestore
    func submitUserToFirestore(with userDictionary: [String:Any], for id:String){
        
        
        db.collection("Users").document("\(id)").setData(userDictionary) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }

        }
        
    }
    
    func submitGeofenceInitialDataToFirestore(with geofenceDictionary: [String:Any], for id:String){
   
        db.collection("GeofenceData").document("\(id)").setData(geofenceDictionary) { (error) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
}
