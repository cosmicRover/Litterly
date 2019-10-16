//
//  SigninVC-Firebase.swift
//  Litterly
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
    
    func initFenceTriggerDocumentForUser(for userId:String){
        let ref = db.collection("GeofenceTriggerTimes").document("\(userId)")
        ref.getDocument { (snapshot, error) in
            if snapshot!.exists{
                //document already exists
            }else{
                ref.setData(["dont" : "delete"], completion: {(error) in
                    if let error = error{
                        print("Print error submitting geofence User: ", error.localizedDescription)
                    }else{
                        print("Succeeded creating geofence data!")
                    }
                })//just a placeholder
            }
        }
    }
    
    func initPointsDocumentForUser(for userId:String){
        let ref = db.collection("Points").document("\(userId)")
        ref.getDocument { (snapshot, error) in
            if snapshot!.exists{
                //document already exists
            }else{
                ref.setData(["dont" : "delete"], completion: {(error) in
                    if let error = error{
                        print("Print error submitting geofence User: ", error.localizedDescription)
                    }else{
                        print("Succeeded creating geofence data!")
                    }
                })//just a placeholder
            }
        }
    }
    
    func submitGeofenceInitialDataToFirestore(with geofenceDictionary: [String:Any], for id:String){
        
        let ref = db.collection("GeofenceData").document("\(id)")
   
        ref.getDocument { (snapshot, error) in
            if snapshot!.exists{
                //do nothing, user already exists
            }else{
                //submit user to the firestore
                ref.setData(geofenceDictionary, completion: { (error) in
                    if let error = error{
                        print("Print error submitting geofence User: ", error.localizedDescription)
                    }else{
                        print("Succeeded creating geofence data!")
                    }
                })
            }
        
        }
        
    }
}
