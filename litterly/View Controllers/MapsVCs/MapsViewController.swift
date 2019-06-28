//
//  MapsViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/5/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import GoogleMaps
import CoreLocation
import Firebase
import FirebaseFirestore
import Geofirestore

//this class holds all the properties for MapsVC

class MapsViewController: UIViewController{
    
    var delegate: HomeControllerDelegate?
    
    //the view state of the card that we will be reffering to
    enum CardState{
        case expanded
        case collapsed
    }
    
    //init some vars
    var cardViewController:CardViewController!
    var visualEffectView:UIVisualEffectView!
    
    //define some costants
    let cardHeight:CGFloat = 345
    let cardHandleAreaHeight:CGFloat = 86
    
    //card is not visible by default
    var cardVisible = false
    
    //next state will return collapsed or expanded based on cardVisibility value
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    //runningAnimations is an array of UIViewPropertyAnimator that we will use to animate our views
    var runningAnimations = [UIViewPropertyAnimator]()
    
    //when animation is interrupted, set the value to 0
    var animatorProgressWhenInterrupted:CGFloat = 0
    
    var mapView: GMSMapView?
    var markers = [GMSMarker]()
    
    //init the location manager for device location
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    var trashModelArray = [TrashDataModel]()
    
    var firestoreCollectionRef:CollectionReference!
    var geoFirestoreRef:GeoFirestore!
    
    
    //icons for map markers. Scheduled/unscheduled
    let organicMarkerIcon = UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal)
    let plasticMarkerIcon = UIImage(named: "water-bottle")?.withRenderingMode(.alwaysOriginal)
    let metalMarkerIcon = UIImage(named: "settings-gears")?.withRenderingMode(.alwaysOriginal)
    
    let scheduledOrganicMarkerIcon = UIImage(named: "green_apple")?.withRenderingMode(.alwaysOriginal)
    let scheduledPlasticMarkerIcon = UIImage(named: "green_bottle")?.withRenderingMode(.alwaysOriginal)
    let scheduledMetalMarkerIcon = UIImage(named: "green_settings_gears")?.withRenderingMode(.alwaysOriginal)
    
    //the custom infoView for the maerkers. loadView loads the xib file
    let unScheduledMarkerInfoWindow = UnscheduledMarkerInfoWindow().loadView()
    let scheduledMarkerInfoWindow = ScheduledMarkerInfoWindow().loadView()
    
    //keeps tarnck of the tapped marker
    var tappedMarker: CLLocationCoordinate2D!
    
    //holds the array element that has been tapped
    var tappedArrayElement:TrashDataModel!
    
    //holds the old values for array element in the event of a modification from firebase
    var oldTappedArrayElement:TrashDataModel!
    
    var justModdedArrayElement:TrashDataModel!
    
    //the query vars for our Geofire circleQuery
    var circleQuery:GFSCircleQuery!, hasLeftNearby:GFSQueryHandle!, hasDocumentMoved:GFSQueryHandle!
    
    //the handler for abobe query vars
    var isNearbyHandle:GFSQueryHandle!
    
    //listener for our direstore database
    var realTimeFirestoreListenerForMarkers:ListenerRegistration!
    
    //an array to hold all the nearbyIds that is being pulled from our databse
    var nearbyIds = [String]()
    
}

