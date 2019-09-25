//
//  MapsViewController.swift
//  Litterly
//
//  Created by Joy Paul on 4/5/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import GoogleMaps
import CoreLocation
import Firebase
import FirebaseFirestore
import Geofirestore
import FirebaseMessaging

//this class holds all the properties for MapsVC

class MapsViewController: UIViewController{
    
    // MARK: Any delegates to conform to
    
    var delegate: HomeControllerDelegate?
    
    //helper func class
    let helper = HelperFunctions()
    
    
    // MARK: Animation properties
    
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
    
    
    // MARK: Marker icons for different types of tyrashes
    
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
    
    
    
    // MARK: Map marker arrays and their buffers
    
    var mapView: GMSMapView?
    
    //buttons for the mapView
    let gpsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
    let nearbyButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
    
    let db = Firestore.firestore()
    
    //init the location manager for device location
    let locationManager = CLLocationManager()
    
    var trashModelArray = [TrashDataModel]()
    
    var markers = [GMSMarker]()
    
    //keeps tarnck of the tapped marker
    var tappedMarker: CLLocationCoordinate2D!
    
    //holds the array element that has been tapped
    var tappedArrayElement:TrashDataModel!
    
    //holds the old values for array element in the event of a modification from firebase
    var oldTappedArrayElement:TrashDataModel!
    
    var justModdedArrayElement:TrashDataModel!
    
    var justRemovedArrayElement:TrashDataModel!
    
    
    // MARK: Nearby queries and their handler + array
    
    //the query vars for our Geofire circleQuery
    
    var firestoreCollectionRef:CollectionReference!
    var geoFirestoreRef:GeoFirestore!
    
    var circleQuery:GFSCircleQuery!, hasLeftNearby:GFSQueryHandle!, hasDocumentMoved:GFSQueryHandle!
    
    //the handler for abobe query vars
    var isNearbyHandle:GFSQueryHandle!
    
    //listener for our direstore database
    var realTimeFirestoreListenerForMarkers:ListenerRegistration!
    
    let nearbyRadius = 0.9 // 9000 meters
    
    //an array to hold all the nearbyIds that is being pulled from our databse
    var nearbyIdsAndTheirDistanceFromUser = [NearbyIdModel]()
    
}

