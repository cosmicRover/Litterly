//
//  MapVC-Geofence.swift
//  litterly
//
//  Created by Joy Paul on 7/17/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import CoreLocation

extension MapsViewController{
    
    //geofence experiments
    
//    func geofenceRegion(with lat:Double, lon:Double) ->CLCircularRegion{
//        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: 200.0, identifier: "region1")
//
//        region.notifyOnEntry = true
//        region.notifyOnExit = true
//
//        return region
//
//    }
//
//    func startMonnitoring(){
//        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
//            print("geofence monitoring isn't available in this Phone")
//            return
//        }
//
//        if CLLocationManager.authorizationStatus() != .authorizedAlways{
//            print("Need always authorization for geofence monitoring")
//        }
//
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
//            let fenceRegion = geofenceRegion(with: 37.33182, lon: -122.03118)
//            locationManager.startMonitoring(for: fenceRegion)
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
//        if region.identifier == "region1"{
//            locationManager.requestState(for: region)
//            print("LOCATION MANAGER HAS STARTED MONITORING")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?,
//                         withError error: Error) {
//        print("@@@@@@@@@@@@@@@@@@@@@Monitoring failed for region with identifier: \(region!.identifier)")
//        print(error.localizedDescription)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location Manager failed with the following error: \(error)")
//    }
//
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
