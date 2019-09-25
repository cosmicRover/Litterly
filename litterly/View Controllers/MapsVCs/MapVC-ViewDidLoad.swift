//
//  MapVC-Vars.swift
//  Litterly
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
import RealmSwift

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
        
        //listening for marker remove event
        NotificationCenter.default.addObserver(self, selector: #selector(removeMarkerInfoWinOnRemove), name: NSNotification.Name("tappedArrayElement-removed"), object: nil)
        
        //listening for marker mod event
        NotificationCenter.default.addObserver(self, selector: #selector(removeMarkerInfoWinOnMod), name: NSNotification.Name("tappedArrayElement-modded"), object: nil)
        
        //uploads the fcm key if it had changed
        helper.checkIfNotificationPermissionWasGiven()
    }
    
    //when view has appeared successfully, we call in to add the sliding card + the listeners
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeTheNavBarClear()
        addMenuAndSearchButtonToNavBar()
        listenForRadius()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("view disappear called!")
        mapView?.clear()
        markers.removeAll()
        trashModelArray.removeAll()
        unScheduledMarkerInfoWindow.removeFromSuperview()
        scheduledMarkerInfoWindow.removeFromSuperview()
        nearbyIdsAndTheirDistanceFromUser.removeAll()
        if (realTimeFirestoreListenerForMarkers != nil){
            realTimeFirestoreListenerForMarkers.remove()
        }
    }
    
    @objc private func manuallyListenForRadius(){
        //show an alert saying an error occoured
        listenForRadius()
    }
    
    //Calling a function to lower the card
    @objc private func reportTapped() {
        print("lowering the card")
        animateTransitionIfNeeded(state: .collapsed, duration: 0.5)
    }
    
    
    //funcs to make the marker info windows disappear
    @objc private func removeMarkerInfoWinOnRemove(){
        guard tappedMarker != nil else {return}
        
        print("tapped array element -> \(String(describing: tappedArrayElement))")
        print("just modded element -> \(String(describing: justModdedArrayElement))")
        
        guard justRemovedArrayElement != nil else {return}
        
        //if id's match, we remove the markerInfoWindow
        if GlobalValues.tappedArrayElementDict.id == justRemovedArrayElement.id{
            unScheduledMarkerInfoWindow.removeFromSuperview()
            scheduledMarkerInfoWindow.removeFromSuperview()
        }
    }
    
    @objc private func removeMarkerInfoWinOnMod(){
        guard tappedMarker != nil else {return}
        
        print("tapped array element -> \(String(describing: tappedArrayElement))")
        print("just modded element -> \(String(describing: justModdedArrayElement))")
        
        guard justModdedArrayElement != nil else {return}
        
        //if id's match, we remove the markerInfoWindow
        if GlobalValues.tappedArrayElementDict.id == justModdedArrayElement.id{
            unScheduledMarkerInfoWindow.removeFromSuperview()
            scheduledMarkerInfoWindow.removeFromSuperview()
        }
    }
}
