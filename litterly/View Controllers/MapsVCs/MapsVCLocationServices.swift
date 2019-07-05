//
//  MapsVCLocationServices.swift
//  litterly
//
//  Created by Joy Paul on 4/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import GoogleMaps
import CoreLocation
import Firebase
import UIKit

//contains all the location permission related cods

extension MapsViewController: CLLocationManagerDelegate{
    
    //check if the location service is actually enabled, if yeah then setup location manager and check the location authorizations
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManger()
            checkLocationAuthorization()
        } else{
            //show an alert to let people kn ow that location services are not enabled
            //checkLocationAuthorization()
        }
    }
    
    
    //sets up location manager. Call when location services are enabled
    func setupLocationManger(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    
    
    //the levels of location authorization and what to do
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
            
        //only gets location when the app is open, the ideal condition
        case .authorizedWhenInUse:
            //centering the mapView on device's location
            centersCameraOnDeviceAndTriggersNearby()
            break
        //when user hasn't picked an allow or not allow auth option, ideal to ask for permission here
        case .notDetermined:
            //requesting when in use permission of location tracking
            locationManager.requestWhenInUseAuthorization()
            break
        //location services can be blocked by the device admin and user can't turn it on/off
        case .restricted:
            //display an alert letting them know what is going on
            break
        //once denied permission, user has to manually enable permissions again
        case .denied:
            //show an alert to let them know how to authorize again
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("Unknown value")
            fatalError()
        }
    }
    
    
    //camera helps center the position of the view, will use user's current location
    func centersCameraOnDeviceAndTriggersNearby(){
        if let location = locationManager.location?.coordinate{
            print(location.latitude)
            print(location.longitude)

            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
            self.mapView?.animate(to: camera)
            self.mapView?.isMyLocationEnabled = true
            self.locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
        }
    }
    
    //if auth changed, run through the switch case statements
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    //gets address from google's reverse geocoding api. Network get request with completion handler
    func reverseGeocodeApi(on lat:Double, and lon:Double, completionHandler: @escaping (String?, String?, Error?) -> Void){
        let apiURL = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lon)&key=\(GoogleApiKey().key)"
        guard let url:URL = URL(string: apiURL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//
                let objects = json as! [String:Any]
                let resultChunk = objects["results"] as! [Any]
                let getAddress = resultChunk[0] as! [String:Any]

                let neighborhoodChunk = getAddress["address_components"] as! [Any]
                let neighborhood = neighborhoodChunk[5] as! [String:Any]

                let userNeighborhood = neighborhood["short_name"] as! String
                let formattedAddress = getAddress["formatted_address"] as! String
                print(formattedAddress)
                completionHandler(formattedAddress, userNeighborhood, nil)
                
            }catch{
                print("error reverseGeocoding " + error.localizedDescription)
                completionHandler("Reverse Geocode error", "Reverse Geocode error", error)
            }
            
        }.resume()
    }
    
    func updateUserCurrentNeighborhood(forUser id:String, with neighborhood:String){
        db.collection("Users").document("\(id)").updateData([
            "neighborhood" : neighborhood
        ]) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
