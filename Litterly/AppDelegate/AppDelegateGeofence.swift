//
//  AppDelegateGeofence.swift
//  Litterly
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
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: radius, identifier: identifier)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        return region
        
    }
    
    func stopMonitoring(lat:Double, lon:Double, identifier:String){
        let region = geofenceRegion(with: lat, lon: lon, identifier: identifier)
        locationManager.stopMonitoring(for: region)
        print("Stopping monitor for \(region)")
    }
    
    func startMonitoring(lat:Double, lon:Double, identifier:String){
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            print("geofence monitoring isn't available in this Phone")
            return
        }

        if CLLocationManager.authorizationStatus() != .authorizedAlways{
            print("Need always authorization for geofence monitoring")
        }

        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            
                let region = geofenceRegion(with: lat, lon: lon, identifier: identifier)
                locationManager.startMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("LOCATION MANAGER HAS STARTED MONITORING WITH \(region.identifier)")
//        locationManager.requestState(for: region)
    }
    
//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        let regionId = region.identifier
//        let userId = Auth.auth().currentUser?.email as! String
//        let time = NSDate().timeIntervalSince1970 //***time in UTC time
//
//        if state == .inside{
//            geofenceIndsideHandler(for: region)
//            updateGeofenceOnTrigger(for: regionId, with: "\(userId)", and: time, fenseStatus: "inside") {(text) in
//                if text != "passed"{
//                    //error occoured sendinng timestamp
//                    print("error sending trigger timestamp for inside")
//                }
//            }
//
//        }else if state == .outside{
//            //geofenceExitHandler(for: region)
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?,
                         withError error: Error) {
        print("@@@@@@@@@@@@@@@@@@@@@Monitoring failed for region with identifier: \(region!.identifier)")
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func geofenceEntranceHandler(for coordinates:CLCircularRegion){
        print("Entered on \(coordinates.identifier)")
        let userId = Auth.auth().currentUser?.email!
        let time = NSDate().timeIntervalSince1970 //***time in UTC time
        
        updateGeofenceOnTrigger(for: coordinates.identifier, with: userId!, and: time, fenseStatus: "inside") {(text) in
            if text != "passed"{
                //error occoured sendinng timestamp
                print("error sending trigger timestamp for outside")
            }else{
               
            }
        }
    }
    
//    func geofenceIndsideHandler(for region:CLRegion){
//        print("Inside on \(region.identifier)")
//    }
    
    func geofenceExitHandler(for coordinates:CLCircularRegion){
        print("Exited on \(coordinates.identifier)")
        let userId = Auth.auth().currentUser?.email!
        let time = NSDate().timeIntervalSince1970 //***time in UTC time
        
        updateGeofenceOnTrigger(for: coordinates.identifier, with: userId!, and: time, fenseStatus: "outside") {(text) in
            if text != "passed"{
                //error occoured sendinng timestamp
                print("error sending trigger timestamp for outside")
            }else{
                //stop monitoring for that region
                print("stop monitoring for", coordinates.identifier)
                self.stopMonitoring(lat: coordinates.center.latitude, lon: coordinates.center.longitude, identifier: coordinates.identifier)
            }
        }
    }
    
    //******TODO: current issue: getting called both at once*******
    
    //gets called as user enters/exits a region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion{
            print("*********Entered fence********* on \(region)")
            let coordinates = region as! CLCircularRegion
            geofenceEntranceHandler(for: coordinates)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion{
            print("*********Exited fence********* on \(region.identifier)")
            let coordinates = region as! CLCircularRegion
            geofenceExitHandler(for: coordinates)
        }
    }
    
}
