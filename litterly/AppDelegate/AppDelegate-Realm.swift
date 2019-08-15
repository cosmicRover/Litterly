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
}
