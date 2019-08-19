//
//  RealmGeofenceSaveModel.swift
//  Litterly
//
//  Created by Joy Paul on 8/14/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

//data model to save the list of objects from firestore
import Foundation
import RealmSwift

class GeofenceRegion: Object{
    @objc dynamic var regionName = ""
    @objc dynamic var lat = 0.0
    @objc dynamic var lon = 0.0
    
    override static func indexedProperties() -> [String]{
        return ["regions"]
    }
}
