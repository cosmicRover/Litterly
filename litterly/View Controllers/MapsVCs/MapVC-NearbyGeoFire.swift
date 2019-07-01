//
//  MapVC-NearbyGeoFire.swift
//  litterly
//
//  Created by Joy Paul on 6/28/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import Geofirestore
import CoreLocation

extension MapsViewController{
    
    //listen for nearby
    func listenForRadius(){
        ///clears existing markers and empties the three arrays
        mapView?.clear()
        markers.removeAll()
        trashModelArray.removeAll()
        nearbyIds.removeAll()
        
        self.queryForNearby(center: locationManager.location!.coordinate, with: nearbyRadius)
        
    }
    
    //listens for any documents that had enetered a given radius
    //define the center, pass it to a firestore query, make sure listeners are observe ready
    //then observe for up to three different events
    //***Note that any modded documents appears as a nearby document even if it had appeared before (duplicate)
    //  thats where the nearbyId array comes in. It tracks any duplicate events and prevents the markers being plotted twice
    func queryForNearby(center centerCamera:CLLocationCoordinate2D, with circleRadius:Double){
        
        let center = CLLocation(latitude: centerCamera.latitude, longitude: centerCamera.longitude)
        print(center)
        
        self.circleQuery = geoFirestoreRef.query(withCenter: center, radius: circleRadius)
        
        let _ = circleQuery.observeReady {
            
            self.isNearbyHandle = self.circleQuery.observe(.documentEntered, with: {(id, location) in
                print("ENTERED NEARBY EVENT ---->\(id! as String) is nearby")
                if self.nearbyIds.contains("\(id! as String)"){
                    print("Id is already in. Nearby count is \(self.nearbyIds.count)")
                    
                } else {
                    self.nearbyIds.append("\(id! as String)")
                    print("Appeneded ID. Nearby count is \(self.nearbyIds.count)")
                    self.cardViewController.nearByCount.fadeTransition(0.3)
                    self.cardViewController.nearByCount.text = "\(self.nearbyIds.count)"
                    self.realTimeMarkerListener(documentId: self.nearbyIds.last!)
                }
                
            })
            
            //remove events
            self.hasLeftNearby = self.circleQuery.observe(.documentExited, with: {(id, location) in
                print("LEFT NEARBY EVENT ---->\(id! as String) has left nearby")
                self.cardViewController.nearByCount.fadeTransition(0.3)
                self.cardViewController.nearByCount.text = "\(self.nearbyIds.count - 1)"
            })
            
            self.hasDocumentMoved = self.circleQuery.observe(.documentMoved, with: {(id, location) in
                print("MOVED NEARBY EVENT ---->*\(id! as String) has been moved")
                
            })
        }
        
        print(self.nearbyIds.count)
        
    }
}
