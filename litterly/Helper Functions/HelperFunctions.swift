//
//  HelperFunctions.swift
//  Litterly
//
//  Created by Joy Paul on 7/4/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Firebase
import UserNotifications

struct HelperFunctions {
    
    let alertService = AlertService()
    
    //finds distance from point a to b
    func findDistanceBetweenTwoMarkers(coordinate1Lat marker1Lat:Double, coordinate1Lon marker1Lon:Double, coordinate2Lat marker2Lat:Double, coordinate2Lat marker2Lon:Double) -> Double{
        let mark1 = CLLocation(latitude: marker1Lat, longitude: marker1Lon)
        let mark2 = CLLocation(latitude: marker2Lat, longitude: marker2Lon)
        let distanceInMeters = mark1.distance(from: mark2)
        
        return distanceInMeters
    }
    
    //find distance between user and marker
    func findDistanceFromUserToMarker(destinationLat lat:Double, destinationLon lon:Double, manager locationManager:CLLocationManager) -> Double{
        
        let deviceCoordinates = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let destinationCoordinate = CLLocation(latitude: lat, longitude: lon)
        
        let distanceInMeters = deviceCoordinates.distance(from: destinationCoordinate)
        
        return distanceInMeters
    }
    
    //convers a calendernum to a weekday
    func convertNumToWeekday(on num:Int) -> String{
        
        switch num{
        case 1:
            return "sunday"
        case 2:
            return "monday"
        case 3:
            return "tuesday"
        case 4:
            return "wednesday"
        case 5:
            return "thursday"
        case 6:
            return "friday"
        case 7:
            return "saturday"
        default:
            return "unknown_day"
            
        }
        
    }
    
    //display the checkmark animation
    func showSuccessAlert(){
        let alert = alertService.alertForGeneral()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    //displays a cross animation
    func showErrorAlert(){
        let alert = alertService.alertForError()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    //Deprecated **DONT USE***
    func getDeviceToken(completionHandler: @escaping (String?) -> Void) {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let file = "deviceToken.txt"
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                let token = try String(contentsOf: fileURL, encoding: .utf8)
                completionHandler("\(token)")
            }
            catch {
                print("error getting token from disk")
                completionHandler("token_not_found")
            }
        }
    }
    
    //get token from current instance of fcm
    func getCurrentFCMId(completion: @escaping (String?) -> Void ){
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error:  \(error)")
                completion("token_not_found")
            } else if let result = result {
                print("Remote instance: \(result.token)")
                completion("\(result.token as String)")
            }
        }
    }
    
    func updateDeviceToken(for user_id:String){
        getCurrentFCMId { (token) in
            let batch = Firestore.firestore().batch()
            let tokenRef = GlobalValues.db.collection("GeofenceData").document("\(user_id)")
            
            batch.updateData(["device_token": "\(token! as String)"], forDocument: tokenRef)
            
            batch.commit { (error) in
                if let err = error{
                    print("error posting token", err.localizedDescription)
                }else{
                    print("successfully posted token")
                }
            }
        }
        
    }
    
    func checkIfNotificationPermissionWasGiven(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.updateDeviceToken(for: GlobalValues.currentUserEmail! as String)
                print("***************NOTIFICATIONS ARE ON*****************")
            }
            else {
                // Either denied or notDetermined
            }
        }
    }
    
    //replaces the device_token on firestore
    func deleteDeviceToken(){
        let db = GlobalValues.db
        let ref = db.collection("GeofenceData").document("\(GlobalValues.currentUserEmail as! String)")
        let batch = Firestore.firestore().batch()
        let updateDeviceTokenValue:[String:String] = ["device_token" : "account_signed_out"]
        
        batch.updateData(updateDeviceTokenValue, forDocument: ref)
        batch.commit { (error) in
            if error != nil{
                print("error deleting firebase device token")
            }else{
                print("submitted device token delete *************")
            }
        }
    }
    
    //finds the difference between a specified UTC time and current utc time
    func minuteParameter(for UTCTime:Double) -> Double{
        //base case when we encounter 0 UTCTime
        if UTCTime == 0{
            return 10
        }
        //else we return the actual remaining minutes
        let currentUTCTime = Date().timeIntervalSince1970
        return (UTCTime - currentUTCTime) / 60
    }
    
    func logoutTheUser(){
        
    }
}
