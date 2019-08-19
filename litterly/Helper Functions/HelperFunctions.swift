//
//  HelperFunctions.swift
//  Litterly
//
//  Created by Joy Paul on 7/4/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import CoreLocation

struct HelperFunctions {
    
    //finds distance from point a to b
    func findDistanceBetweenTwoMarkers(coordinate1Lat marker1Lat:Double, coordinate1Lon marker1Lon:Double, coordinate2Lat marker2Lat:Double, coordinate2Lat marker2Lon:Double) -> Double{
        let mark1 = CLLocation(latitude: marker1Lat, longitude: marker1Lon)
        let mark2 = CLLocation(latitude: marker2Lat, longitude: marker2Lon)
        let distanceInMeters = mark1.distance(from: mark2)
        
        return distanceInMeters
    }
    
    //find distance between user and marker
    func findDistanceFromUserToMarker(destinationLat lat:Double, destinationLon lon:Double, manager locationManager:CLLocationManager) -> Double{
        
        let deviceCoordinates = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let destinationCoordinate = CLLocation(latitude: lat, longitude: lon)
        
        let distanceInMeters = deviceCoordinates.distance(from: destinationCoordinate)
        
        return distanceInMeters
    }
}
