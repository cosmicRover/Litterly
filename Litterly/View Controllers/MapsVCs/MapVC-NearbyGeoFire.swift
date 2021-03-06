//
//  MapVC-NearbyGeoFire.swift
//  Litterly
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
        unScheduledMarkerInfoWindow.removeFromSuperview()
        scheduledMarkerInfoWindow.removeFromSuperview()
        nearbyIdsAndTheirDistanceFromUser.removeAll()
        if (realTimeFirestoreListenerForMarkers != nil){
            realTimeFirestoreListenerForMarkers.remove()
        }
        
        if let location = locationManager.location?.coordinate{
            self.queryForNearby(center: location, with: self.nearbyRadius)
        }
        
    }
    
    //listens for any documents that had enetered a given radius
    //define the center, pass it to a firestore query, make sure listeners are observe ready
    //then observe for up to three different events
    //***Note that any modded documents appears as a nearby document even if it had appeared before (duplicate)
    //  thats where the nearbyId array comes in. It tracks any duplicate events and prevents the markers being plotted twice
    func queryForNearby(center centerCamera:CLLocationCoordinate2D, with circleRadius:Double){
        
        let center = CLLocation(latitude: centerCamera.latitude, longitude: centerCamera.longitude)
        var nearbyCounter:Int = 0
        print(center)
        
        self.circleQuery = geoFirestoreRef.query(withCenter: center, radius: circleRadius)
        
        let _ = circleQuery.observeReady {
            
            self.isNearbyHandle = self.circleQuery.observe(.documentEntered, with: {(id, location) in
                print("ENTERED NEARBY EVENT ---->\(id! as String) is nearby")
                if self.nearbyIdsAndTheirDistanceFromUser.contains(where: {$0.nearby_id == "\(id! as String)"})
                {
                    print("Id is already in. Nearby count is \(self.nearbyIdsAndTheirDistanceFromUser.count)")
                    
                } else {
                    
                    ///*** should move all the marker related array to the singleton instance for better access
                    let helper = HelperFunctions()
                    let nearby_id:String = id! as String
                    let nearby_id_lat:Double = location?.coordinate.latitude as! Double
                    let nearby_id_lon:Double = location?.coordinate.longitude as! Double
                    
                    let nearby_id_distance_from_user = helper.findDistanceFromUserToMarker(destinationLat: nearby_id_lat, destinationLon: nearby_id_lon, manager: self.locationManager)
                    let nearbyDataToAppend:NearbyIdModel = NearbyIdModel(nearby_id: nearby_id, nearby_id_lat: nearby_id_lat, nearby_id_lon: nearby_id_lon, nearby_id_distance: nearby_id_distance_from_user)
                    
                    self.nearbyIdsAndTheirDistanceFromUser.append(nearbyDataToAppend)
                    print("Appeneded Nearby item. Nearby count is \(self.nearbyIdsAndTheirDistanceFromUser.count)")
                    self.cardViewController.nearByCount.fadeTransition(0.3)
                    nearbyCounter += 1
                    self.cardViewController.nearByCount.text = "\(nearbyCounter)"
                    
                    self.realTimeMarkerListener(documentId: self.nearbyIdsAndTheirDistanceFromUser.last!.nearby_id)
                    
                    print(self.nearbyIdsAndTheirDistanceFromUser.last?.dictionary as! [String : Any])
                }
            })
            
            //remove events
            self.hasLeftNearby = self.circleQuery.observe(.documentExited, with: {(id, location) in
                print("LEFT NEARBY EVENT ---->\(id! as String) has left nearby")
                
                //**** experimental
//                let mockData = TrashDataModel(id: "removed", author: "removed", lat: 999999, lon: 999999, trash_type: "removed", street_address: "removed", is_meetup_scheduled: false)
//                let index = self.findTheIndexOnNearbyMarkers(with: "\(id as! String)")
//                self.nearbyIdsAndTheirDistanceFromUser.remove(at: index)
//                    NearbyIdModel(nearby_id: "removed", nearby_id_lat: 99.99, nearby_id_lon: 99.99, nearby_id_distance: 999)
                //**** experimental
                
                self.cardViewController.nearByCount.fadeTransition(0.3)
                nearbyCounter -= 1
                self.cardViewController.nearByCount.text = "\(nearbyCounter)"
            })
            
            self.hasDocumentMoved = self.circleQuery.observe(.documentMoved, with: {(id, location) in
                print("MOVED NEARBY EVENT ---->*\(id! as String) has been moved")
                
            })
        }
        
        print(self.nearbyIdsAndTheirDistanceFromUser.count)
        
    }
}
