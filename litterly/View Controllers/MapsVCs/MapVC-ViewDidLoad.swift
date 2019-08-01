//
//  MapVC-Vars.swift
//  litterly
//
//  Created by Joy Paul on 6/28/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation
import Firebase
import FirebaseFirestore
import Geofirestore

extension MapsViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        checkLocationServices()
        addSlideInCardToMapView()
        mapView?.delegate = self
        
        //init nearby firestore ref
        firestoreCollectionRef = db.collection("TaggedTrash")
        geoFirestoreRef = GeoFirestore(collectionRef: firestoreCollectionRef)
        
        //listening for buttonTapped
        NotificationCenter.default.addObserver(self, selector: #selector(reportTapped), name: NSNotification.Name("reportTapped"), object: nil)
        
        //listening for marker modification event
        NotificationCenter.default.addObserver(self, selector: #selector(updateTappedArrayElement), name: NSNotification.Name("tappedArrayElement-reloaded"), object: nil)
        
        //startMonnitoring()
        listenForRadius()
        
    }
    
    //when view has appeared successfully, we call in to add the sliding card + the listeners
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeTheNavBarClear()
        addMenuAndSearchButtonToNavBar()
    }
    
    //Calling a function to lower the card
    @objc private func reportTapped() {
        print("lowering the card")
        animateTransitionIfNeeded(state: .collapsed, duration: 0.5)
    }
    
    //calling a func to re-assign userAssignedElement
    @objc private func updateTappedArrayElement(){
        guard tappedMarker != nil else {return}
        
        print("tapped array element -> \(String(describing: tappedArrayElement))")
        print("just modded element -> \(String(describing: justModdedArrayElement))")
        
        guard justModdedArrayElement != nil else {return}
        
        //if id's match, we remove the markerInfoWindow
        if tappedArrayElement.id == justModdedArrayElement.id{
            unScheduledMarkerInfoWindow.removeFromSuperview()
            scheduledMarkerInfoWindow.removeFromSuperview()
        }
    }
}
