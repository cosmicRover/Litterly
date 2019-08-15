//
//  Appdelegate-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 8/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

extension AppDelegate{
    
    func getGeofenceDataFromFirestore(for userId:String, on day:String, completion: @escaping (String?) -> Void){
        
        let db = Firestore.firestore()
        let geofenceRef = db.collection("GeofenceData").document("\(userId)")
        
        geofenceRef.getDocument { (snapshot, error) in
            
            if let error = error{
                print("error getting geofenc -> ", error.localizedDescription)
                return
            }
            
            let data = snapshot?.data()
            let geofenceData = data!["\(day)"]
            
            print(geofenceData as! [[String:Double]])
            
            completion("ok")
            
            
        }
        
    }
    
}
