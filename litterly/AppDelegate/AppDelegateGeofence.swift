//
//  AppDelegateGeofence.swift
//  litterly
//
//  Created by Joy Paul on 7/17/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import Firebase

//geofence experiments

extension AppDelegate: CLLocationManagerDelegate{
    func geofenceRegion(with lat:Double, lon:Double, identifier:String) ->CLCircularRegion{
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: 50.0, identifier: identifier)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        return region
        
    }
    
    func startMonnitoring(){
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            print("geofence monitoring isn't available in this Phone")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways{
            print("Need always authorization for geofence monitoring")
        }
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            for x in geofencedLocations{
                let region = geofenceRegion(with: x["lat"] as! Double, lon: x["lon"] as! Double, identifier: x["name"] as! String)
                locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("LOCATION MANAGER HAS STARTED MONITORING WITH \(region.identifier)")
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let regionId = region.identifier
        let userId = Auth.auth().currentUser?.email as! String
        let time = NSDate().timeIntervalSince1970
        
        if state == .inside{
            geofenceIndsideHandler(for: region)
            updateGeofenceOnTrigger(for: "\(regionId)inside", with: "\(userId)", and: "\(time)")
            
        } else if state == .outside{
            geofenceExitHandler(for: region)
            updateGeofenceOnTrigger(for: "\(regionId)outside", with: "\(userId)", and: "\(time)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?,
                         withError error: Error) {
        print("@@@@@@@@@@@@@@@@@@@@@Monitoring failed for region with identifier: \(region!.identifier)")
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func geofenceEntranceHandler(for region:CLRegion){
        print("Entered on \(region.identifier)")
    }
    
    func geofenceIndsideHandler(for region:CLRegion){
        print("Inside on \(region.identifier)")
    }
    
    func geofenceExitHandler(for region:CLRegion){
        print("Exited on \(region.identifier)")
    }
    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//
//        if region is CLCircularRegion{
//            print("*********Entered fence*********")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if region is CLCircularRegion{
//            print("*********exited fence*********")
//        }
//    }
    
    //func to append data to firestore, to check if geofence gets triggered when the app is terminated. Needs more testing though
    
    func updateGeofenceOnTrigger(for id:String, with userId:String, and time:String){
        let db = Firestore.firestore()
        let batch = Firestore.firestore().batch()
        let meetupRef = db.collection("GeofenceProof").document("\(id)")
        
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
}
