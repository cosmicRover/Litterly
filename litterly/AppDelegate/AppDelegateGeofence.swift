//
//  AppDelegateGeofence.swift
//  litterly
//
//  Created by Joy Paul on 7/17/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import CoreLocation

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
        if state == .inside{
            geofenceIndsideHandler(for: region)
        } else if state == .outside{
            geofenceExitHandler(for: region)
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
}
