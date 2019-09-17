//
//  SideMennuFirebase.swift
//  Litterly
//
//  Created by Joy Paul on 9/16/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

extension ContainerController{
    
    //replaces the device_token on firestore
    func deleteDeviceTokenn(){
        let db = GlobalValues.db
        let ref = db.collection("GeofenceData").document("\(GlobalValues.currentUserEmail as! String)")
        let batch = Firestore.firestore().batch()
        let updateDeviceTokenValue:[String:String] = ["device_token" : "account_signed_out"]
        
        batch.updateData(updateDeviceTokenValue, forDocument: ref)
        batch.commit { (error) in
            if error != nil{
                print("error deleting firebase device token")
            }else{
                print("submitted device token delete *************")
            }
        }
        
    }
}
