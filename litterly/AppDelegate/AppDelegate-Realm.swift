//
//  AppDelegate-Realm.swift
//  litterly
//
//  Created by Joy Paul on 8/14/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import RealmSwift

extension AppDelegate{
    
    func saveGeofenceDataToRealm(regionName name:String, regionLat lat:Double, regionLon lon:Double){
        
        let realm = try! Realm()
        
        let region = GeofenceRegion()
        
        region.regionName = "\(name)"
        region.lat = lat
        region.lon = lon
        
        try! realm.write {
            realm.add(region)
        }
        
    }
    
    func deletePreviousGeofenceDataAndStopMonitoring(completionHandler: @escaping (String?)-> Void){
        let realm = try! Realm()
        
        let fence = realm.objects(GeofenceRegion.self)
        
        for data in fence{
            
            let regionName = data["regionName"] as! String
            let lat = data["lat"] as! Double
            let lon = data["lon"] as! Double
            
            stopMonitoring(lat: lat, lon: lon, identifier: regionName)
        }
        
        print("stopped previous geofence monitoring")
        
        try! realm.write{
            
            realm.delete(fence)
        }
        
        completionHandler("ok")
    }
    
    func readRealmDataAndStartMonitoring(completionHandler: @escaping (String?)-> Void){
        let realm = try! Realm()
        
        let fence = realm.objects(GeofenceRegion.self)
        
        for data in fence{
            
            let regionName = data["regionName"] as! String
            let lat = data["lat"] as! Double
            let lon = data["lon"] as! Double
            
            startMonitoring(lat: lat, lon: lon, identifier: regionName)
        }
        
        completionHandler("ok")
        
    }
}
