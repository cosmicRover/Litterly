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
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    let geofencedLocations:[[String:Any]] = [["lat" : 41.43557351415048, "lon" : -102.62374330504326, "name" :"reg1"],
                                             ["lat" : 27.064346022727918, "lon" : -102.1177372407189, "name" :"reg2"],
                                             ["lat" : 33.32624671918817, "lon" : -94.2954716157189, "name" :"reg3"]
//                                             ["lat" : 36.88430948989517, "lon" : -83.9243778657189, "name" :"reg4"],
//                                             ["lat" : 42.46021248391089, "lon" : -72.4107059907189, "name" :"reg5"],
//                                             ["lat" : 44.343757683867764, "lon" : -95.5698856782189, "name" :"reg6"],
//                                             ["lat" : 47.19369599399806, "lon" : -110.5112919282189, "name" :"reg7"],
//                                             ["lat" : 43.073170033674906, "lon" : -114.5542606782189, "name" :"reg8"],
//                                             ["lat" : 39.745493773672706, "lon" : -109.5884403657189, "name" :"reg9"],
//                                             ["lat" : 35.322149385664,  "lon" : -110.8189091157189, "name" :"reg10"],
//                                             ["lat" : 36.81397790218795, "lon" : -115.7847294282189, "name" :"reg11"],
//                                             ["lat" : 40.95114122329817, "lon" : -120.2671513032189, "name" :"reg12"],
//                                             ["lat" : 44.45270628870652, "lon" : -119.6958622407189, "name" :"reg13"],
//                                             ["lat" : 43.70607746047087, "lon" : -109.51588815290665, "name" :"reg14"],
//                                             ["lat" : 40.445351046514, "lon" : -106.52760690290665, "name" :"reg15"],
//                                             ["lat" : 37.01842371658437, "lon" : -106.13209909040665, "name" :"reg16"],
//                                             ["lat" : 36.13618099003744, "lon" : -106.08815377790665, "name" :"reg17"],
//                                             ["lat" : 35.816112547985355, "lon" : -106.08815377790665, "name" :"reg18"],
//                                             ["lat" : 33.135795050774846, "lon" : -106.92311471540665, "name" :"reg19"]
                                             ]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("\(GoogleApiKey().key)")
        GMSPlacesClient.provideAPIKey("\(GoogleApiKey().key)")
        FirebaseApp.configure()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        
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
        
        startMonnitoring()
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
