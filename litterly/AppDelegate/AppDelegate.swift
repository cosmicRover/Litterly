//
//  AppDelegate.swift
//  litterly
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    let locationManager = CLLocationManager()
    let geofencedLocations:[[String:Any]] = [["lat" : 41.43557351415048, "lon" : -102.62374330504326, "name" :"reg1"],
                                             ["lat" : 27.064346022727918, "lon" : -102.1177372407189, "name" :"reg2"],
                                             ["lat" : 33.32624671918817, "lon" : -94.2954716157189, "name" :"reg3"]]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //init google stuff
        GMSServices.provideAPIKey("\(GoogleApiKey().key)")
        GMSPlacesClient.provideAPIKey("\(GoogleApiKey().key)")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        //init location for geofence
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        //init push notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        routeTheUser()
        //startMonnitoring()
        
        return true
    }
    
    func routeTheUser(){
        //if user didn't sign out, send the user directly to the mapsVC
        if Auth.auth().currentUser != nil{
            print("User already signed in \(Auth.auth().currentUser?.displayName as! String)")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let mapsViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerVC")
            
            self.window?.rootViewController = mapsViewController
            
        } else {
            print("User needs to sign in again")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let mapsViewController = storyBoard.instantiateViewController(withIdentifier: "IntroPageVC")
            
            self.window?.rootViewController = mapsViewController
        }
    }
    
    
    //push notification callBack handlers
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    //*******for silent push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //startMonnitoring()
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

}
