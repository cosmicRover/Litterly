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
        nearbyIdsAndTheirDistanceFromUser.removeAll()
        
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
                if self.nearbyIdsAndTheirDistanceFromUser.contains(where: {$0.nearby_id == "\(id! as String)"})
                {
                    print("Id is already in. Nearby count is \(self.nearbyIdsAndTheirDistanceFromUser.count)")
                    
                } else {
                    
                    ///*** should move all the marker related array to the singleton instance for better access
                    
                    let nearby_id:String = id! as String
                    let nearby_id_lat:Double = location?.coordinate.latitude as! Double
                    let nearby_id_lon:Double = location?.coordinate.longitude as! Double
                    
                    let nearby_id_distance_from_user = self.findDistanceFromUserToMarker(destinationLat: nearby_id_lat, destinationLon: nearby_id_lon)
                    
                    let nearbyDataToAppend:NearbyIdModel = NearbyIdModel(nearby_id: nearby_id, nearby_id_lat: nearby_id_lat, nearby_id_lon: nearby_id_lon, nearby_id_distance_from_user: nearby_id_distance_from_user)
                    
                    self.nearbyIdsAndTheirDistanceFromUser.append(nearbyDataToAppend)
                    print("Appeneded Nearby item. Nearby count is \(self.nearbyIdsAndTheirDistanceFromUser.count)")
                    self.cardViewController.nearByCount.fadeTransition(0.3)
                    self.cardViewController.nearByCount.text = "\(self.nearbyIdsAndTheirDistanceFromUser.count)"
                    self.realTimeMarkerListener(documentId: self.nearbyIdsAndTheirDistanceFromUser.last!.nearby_id)
                    
                    print(self.nearbyIdsAndTheirDistanceFromUser.last?.dictionary as! [String : Any])
                }
                
            })
            
            //remove events
            self.hasLeftNearby = self.circleQuery.observe(.documentExited, with: {(id, location) in
                print("LEFT NEARBY EVENT ---->\(id! as String) has left nearby")
                self.cardViewController.nearByCount.fadeTransition(0.3)
                self.cardViewController.nearByCount.text = "\(self.nearbyIdsAndTheirDistanceFromUser.count - 1)"
            })
            
            self.hasDocumentMoved = self.circleQuery.observe(.documentMoved, with: {(id, location) in
                print("MOVED NEARBY EVENT ---->*\(id! as String) has been moved")
                
            })
        }
        
        print(self.nearbyIdsAndTheirDistanceFromUser.count)
        
    }
    
    //find distance between two markers
    func findDistanceFromUserToMarker(destinationLat lat:Double, destinationLon lon:Double) -> Double{
        
        let deviceCoordinates = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let destinationCoordinate = CLLocation(latitude: lat, longitude: lon)
        
        let distanceInMeters = deviceCoordinates.distance(from: destinationCoordinate)
        
        return distanceInMeters
    }
}
