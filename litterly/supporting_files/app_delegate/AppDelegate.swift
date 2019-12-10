//
//  AppDelegate.swift
//  Litterly
//
//  Created by Joy Paul on 4/5/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseMessaging
import FirebaseFirestore
import UserNotifications
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //init google stuff
        GMSServices.provideAPIKey("\(GoogleApiKey().key)")
        GMSPlacesClient.provideAPIKey("\(GoogleApiKey().key)")
        
        routeUser()
        
        return true
    }
    
    func routeUser(){
        window = UIWindow()
        window?.rootViewController = IntroVC()
        window?.makeKeyAndVisible()
    }
}
