//
//  GoogleMapsViewController.swift
//  Litterly
//
//  Created by Joy Paul on 4/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseFirestore
import Geofirestore

extension MapsViewController {
    
    //init the GMS view **must check for internet connection first**
    func initMapView(){
        
        if let location = locationManager.location?.coordinate{
            print(location.latitude)
            print(location.longitude)
            
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 13.0)
            //***note the value 86, it is the height of the handleArea and the map's view must end before it touches handle area
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 86), camera: camera)
            
            reverseGeocodeApi(on: location.latitude, and: location.longitude) { (formattedAddress, city, error) in
                let user = GlobalValues.currentUserEmail
                
                self.updateUserCurrentNeighborhood(forUser: "\(user! as String)", with: "\(city! as String)")
                print("updated user city")
            }
            
            //adding the mapsView as subview to the parent view
            self.view.addSubview(mapView!)
            locateMeButton()
            segueToNearbyButton()
            
        } else { //else pass a default coordinate to center the location
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 86), camera: GMSCameraPosition.camera(withLatitude: 40.74069, longitude: -73.983114, zoom: 15))

            self.view.addSubview(mapView!)
            locateMeButton()
            segueToNearbyButton()
        }
        
    }
    
    //add a button to help center the screen position on device location
    func locateMeButton(){
        gpsButton.backgroundColor = UIColor.textWhite
        
        gpsButton.setImage(UIImage(named: "52gps"), for: .normal)
        
        gpsButton.translatesAutoresizingMaskIntoConstraints = false
        mapView?.addSubview(gpsButton)
        
        gpsButton.addTarget(self, action: #selector(onLocateMeTap(sender:)), for: .touchUpInside)
        
        
        gpsButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        gpsButton.bottomAnchor.constraint(equalTo: mapView!.bottomAnchor, constant: -16).isActive = true
        gpsButton.rightAnchor.constraint(equalTo: mapView!.rightAnchor, constant: -16).isActive = true
        
        gpsButton.layer.cornerRadius = 12
        gpsButton.layer.shadowRadius = 50
        gpsButton.layer.shadowColor = UIColor.searchBoxShadowColor.cgColor
    }
    
    @objc func onLocateMeTap(sender: UIButton){
        print("locate me tapped")
        checkLocationServices()
        
        if let location = locationManager.location?.coordinate{
        print("TAP ME!! Location data")
        print("\(location.latitude)")
        print("\(location.longitude)")
            
        print("removing circleQuery observer")
            
        if (realTimeFirestoreListenerForMarkers != nil){
            print("marker Listener is active")
            realTimeFirestoreListenerForMarkers.remove()
            circleQuery.removeObserver(withHandle: self.isNearbyHandle)
            circleQuery.removeObserver(withHandle: self.hasLeftNearby)
            circleQuery.removeObserver(withHandle: self.hasDocumentMoved)
        } else {
            print("marker Listener is inactive")
        }
        
        //removing the observers before creating new ones again
        
        print("adding new observers based on current location")
        self.listenForRadius()
            
        }
    }
    
    //add a button to segue to nearby
    func segueToNearbyButton(){
        nearbyButton.backgroundColor = UIColor.textWhite
        
        nearbyButton.setImage(UIImage(named: "52bino"), for: .normal)
        
        nearbyButton.translatesAutoresizingMaskIntoConstraints = false
        mapView?.addSubview(nearbyButton)
        
        nearbyButton.addTarget(self, action: #selector(onNearbyTap(sender:)), for: .touchUpInside)
        
        nearbyButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        nearbyButton.bottomAnchor.constraint(equalTo: gpsButton.topAnchor, constant: -8).isActive = true
        nearbyButton.rightAnchor.constraint(equalTo: mapView!.rightAnchor, constant: -16).isActive = true
        
        nearbyButton.layer.cornerRadius = 12
        nearbyButton.layer.shadowRadius = 50
        nearbyButton.layer.shadowColor = UIColor.searchBoxShadowColor.cgColor
    }
    
    @objc func onNearbyTap(sender: UIButton){
        print("nearby tapped")

        let storyBoard: UIStoryboard = UIStoryboard(name: "Nearby", bundle: .main)

        let NearbyVC = storyBoard.instantiateViewController(withIdentifier: "NearbyScreen") as! NearbyViewController
        NearbyVC.modalPresentationStyle = .fullScreen
        let navController = UINavigationController(rootViewController: NearbyVC)

        self.present(navController, animated: true, completion: nil)
        
    }
}
