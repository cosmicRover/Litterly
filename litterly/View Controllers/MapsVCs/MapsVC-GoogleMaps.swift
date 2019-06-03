//
//  GoogleMapsViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseFirestore

extension MapsViewController {
    
    //init the GMS view **must check for internet connection first**
    func initMapView(){
        
        if let location = locationManager.location?.coordinate{
            print(location.latitude)
            print(location.longitude)
            
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 13.0)
            //***note the value 86, it is the height of the handleArea and the map's view must end before it touches handle area
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 86), camera: camera)
            
            //getMarkersFromFireStore()
            realTimeMarkerListener()
            
            //adding the mapsView as subview to the parent view
            self.view.addSubview(mapView!)
            locateMeButton()
            
        } else { //else pass a default coordinate to center the location
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 86), camera: GMSCameraPosition.camera(withLatitude: 40.74069, longitude: -73.983114, zoom: 15))
            
            //getMarkersFromFireStore()
            realTimeMarkerListener()
            
            self.view.addSubview(mapView!)
            locateMeButton()
        }
        
    }
    
    //add a button to help center the screen position on device location
    func locateMeButton(){
        let gpsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
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
    }
}
