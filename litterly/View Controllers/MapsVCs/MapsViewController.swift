//
//  MapsViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/5/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase
import FirebaseFirestore

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
    
    lazy var customSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let searchBox = UITextField()
    
    let db = Firestore.firestore()
    
    var trashModelArray = [TrashDataModel]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        checkLocationServices()
        addSlideInCardToMapView()
        mapView?.delegate = self
        
        //listening for buttonTapped
        NotificationCenter.default.addObserver(self, selector: #selector(reportTapped), name: NSNotification.Name("reportTapped"), object: nil)
        
        //listening for marker modification event
        NotificationCenter.default.addObserver(self, selector: #selector(updateTappedArrayElement), name: NSNotification.Name("tappedArrayElement-reloaded"), object: nil)
    }
    
    //when view has appeared successfully, we call in to add the sliding card
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeTheNavBarClear()
        addASearchBar()
    }
    
    //Calling a function to lower the card
    @objc private func reportTapped() {
        print("lowering the card")
        animateTransitionIfNeeded(state: .collapsed, duration: 0.5)
    }
    
    //calling a func to re-assign userAssignedElement
    @objc private func updateTappedArrayElement(){
        guard tappedMarker != nil else {return}
        
        //TODO: fix nil value when checking for matching id
        
//        if (tappedArrayElement.id == justModdedArrayElement.id){
//            unScheduledMarkerInfoWindow.removeFromSuperview()
//            scheduledMarkerInfoWindow.removeFromSuperview()
//        }
        
        unScheduledMarkerInfoWindow.removeFromSuperview()
        scheduledMarkerInfoWindow.removeFromSuperview()
    }
}

