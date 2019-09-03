//
//  Appdelegate-Firebase.swift
//  Litterly
//
//  Created by Joy Paul on 8/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import RealmSwift

extension AppDelegate{
    
    //get the geofence coordinates and save to realm
    func getGeofenceDataFromFirestore(for userId:String, on day:String, completion: @escaping (String?) -> Void){
        
        let db = Firestore.firestore()
        let geofenceRef = db.collection("GeofenceData").document("\(userId)")
        
        geofenceRef.getDocument { (snapshot, error) in
            
            if let error = error{
                print("error getting geofenc -> ", error.localizedDescription)
                return
            }
            
            let data = snapshot?.data()
            let geofenceData = data!["\(day)"] as! [[String:Double]]
            var count = 0
            
            for x in geofenceData{
                
                if count == 0{
                    count += 1
                    continue
                }
                
                self.saveGeofenceDataToRealm(regionName: "region\(count)", regionLat: x["lat"]!, regionLon: x["lon"]!)
                count += 1
            }
            
            completion("ok")
            
        }
        
    }
    
    //need to approach ot on a different way. It will be for the point system
    func updateGeofenceOnTrigger(for id:String, with userId:String, and time:String){
        let db = Firestore.firestore()
        let batch = Firestore.firestore().batch()
        let meetupRef = db.collection("GeofenceProof").document("\(userId)")
        
        batch.setData([
            "geofence_region_id" : FieldValue.arrayUnion(["\(id)"]),
            "users_id": FieldValue.arrayUnion(["\(userId)"]),
            "time_stamp": FieldValue.arrayUnion(["\(time)"])
            ], forDocument: meetupRef)
        
        batch.commit { (err) in
            if let err = err{
                print(err.localizedDescription)
                //show error  alert
            } else{
                print("update commited successfully")
            }
        }
    }
    
    //erase the day array and the count to default values
    func eraseGeofenceToDefaultAndSetDayCountToZero(for documentId:String, on day:String){
        let db = Firestore.firestore()
        let batch = Firestore.firestore().batch()
        let geofenceDocRef = db.collection("GeofenceData").document("\(documentId)")
 
        batch.updateData([
            "\(day)" : [["lat" : 0, "lon" : 0]]
            ], forDocument: geofenceDocRef)
        
        batch.updateData(
            ["\(day)_count" : 0],
            forDocument: geofenceDocRef)
        
        batch.commit { (err) in
            if let err = err{
                print(err.localizedDescription)
                //show error  alert
            } else{
                print("erase updated \(day)'s geofence successfully")
            }
        }
    }
    
    
}
