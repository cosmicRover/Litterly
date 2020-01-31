//
//  MapsVC-Firebase.swift
//  Litterly
//
//  Created by Joy Paul on 4/26/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//
import UIKit
import GoogleMaps
import FirebaseFirestore
import FirebaseMessaging
import Firebase
import GeoFire

extension MapsViewController{
    
    //returns a custom map marker based on trashType
    func assignAMarkerIcon(for location:CLLocationCoordinate2D, on trashType:String, and isMeetupScheduled:Bool) -> GMSMarker{
        
        let customMarker = GMSMarker(position: location)
        
        if trashType == "organic"{
            if isMeetupScheduled{
                customMarker.icon = self.scheduledOrganicMarkerIcon
            }else{
                customMarker.icon = self.organicMarkerIcon
            }
            
            return customMarker
        } else if trashType == "plastic"{
            if isMeetupScheduled{
                customMarker.icon = self.scheduledPlasticMarkerIcon
            }else{
                customMarker.icon = self.plasticMarkerIcon
            }
            
            return customMarker
        } else {
            if isMeetupScheduled{
                customMarker.icon = self.scheduledMetalMarkerIcon
            }else{
                customMarker.icon = self.metalMarkerIcon
            }
            
            return customMarker
        }
        
    }
    
    //return a marker with proper marker properties based on the expiration minutes
    //The purpose is that it will not allow anyone to schecule meetup if the marker is about to expire
    //can be modified for different outcomes as well
    func assignMarkerProperty(expirationTime:Double, isMeetupScheduled:Bool, marker:GMSMarker) -> GMSMarker{
        if (expirationTime > 10.0 && isMeetupScheduled == false) || (expirationTime > 10.0 && isMeetupScheduled == true){
            marker.opacity = 0.8
            marker.appearAnimation = .pop
            return marker
        }else if expirationTime <= 10 && isMeetupScheduled == true{
            marker.opacity = 0.8
            marker.appearAnimation = .pop
            return marker
        }else{
            marker.opacity = 0.1
            marker.isTappable = false
            marker.appearAnimation = .pop
            return marker
        }
    }
    
    //a listener for markers in real time from other users
    func realTimeMarkerListener(documentId id:String){
        
        //adds snapshot listeners for documents with the specefied ids only
       self.realTimeFirestoreListenerForMarkers =  db.collection("TaggedTrash").whereField("id", isEqualTo: "\(id)")
            .addSnapshotListener{
            QuerySnapshot, Error in
            
            //chceking if the database we query for is empty
            guard let snapShot = QuerySnapshot else {return}
            
            snapShot.documentChanges.forEach{
                diff in
                
                //if added
                if diff.type == .added{
                    //self.trashModelArray.append(TrashDataModel(dictionary: diff.document.data())!)
                    
                    print("Document diff gets called")
                    
                    self.trashModelArray.append(TrashDataModel(dictionary: diff.document.data())!)
                    
                    let isMeetupScheduled = self.trashModelArray.last!.is_meetup_scheduled
                    print(isMeetupScheduled)
                    
                    let expirationTime = self.helper.minuteParameter(for: self.trashModelArray.last!.expiration_date)
                    let position = CLLocationCoordinate2D(latitude: self.trashModelArray.last!.lat, longitude: self.trashModelArray.last!.lon)
                    let trashType = self.trashModelArray.last!.trash_type
                    
                    let marker = self.assignAMarkerIcon(for: position, on: trashType, and: isMeetupScheduled)
                    let filledMarker = self.assignMarkerProperty(expirationTime: expirationTime, isMeetupScheduled: isMeetupScheduled, marker: marker)
                    self.markers.append(filledMarker)
                    self.markers.last?.map = self.mapView
                    
                    print("TYPE ADDED->> \(diff.document.data())")
                    print("EXPIRATION TIME --> ",expirationTime)
                    
                    //if removed (when a clean up is complete, add a ghost trail of the previous marker
                } else if diff.type == .removed{
                    
                    print("------------>>>> REMOVE TRIGGERED")
                    print("REMOVED DATA ---->> \(diff.document.data()) AND ARR COUNT ->>> \(self.trashModelArray.count)")
                    
                    let data = TrashDataModel(dictionary: diff.document.data())
                    let index = self.findTheIndexWithId(with: data!.id as String)
                    
                    self.justRemovedArrayElement = data
                    NotificationCenter.default.post(name: NSNotification.Name("tappedArrayElement-removed"), object: nil)
                    
                    let placeholderData = TrashDataModel(id: self.trashModelArray[index].id, author: self.trashModelArray[index].author, lat: 90.0, lon: 180.0, trash_type: self.trashModelArray[index].trash_type, timezone: self.trashModelArray[index].timezone, street_address: self.trashModelArray[index].street_address, is_meetup_scheduled: self.trashModelArray[index].is_meetup_scheduled, expiration_date: self.trashModelArray[index].expiration_date)
                    
                    self.trashModelArray[index] = placeholderData
                    
                    //disabling the markers from being tapped. It will get removed next time the map updates
                    self.markers[index].isTappable = false
                    self.markers[index].opacity = 0.1

                    //or modified an existing one (when a cleanup is scheduled)
                } else if diff.type == .modified{
                    
                    print("------------>>>> MOD TRIGGERED")
                    
                    //self.oldTappedArrayElement = self.tappedArrayElement
                    
                    let data = TrashDataModel(dictionary: diff.document.data())
                    //gets the index of the modded data with the lat and long
                    let index = self.findTheIndexOnTrashModelArrAndMarkers(with: data!.lat, and: data!.lon)
                    
                    //assigning a reference to the modded data
                    self.justModdedArrayElement = data
                    //and then posting a notification to modify the array
                    NotificationCenter.default.post(name: NSNotification.Name("tappedArrayElement-modded"), object: nil)
                    
                    print("The index of the modded data ->>> \(index)")
                    print("Before change ->>> \(self.trashModelArray[index])")
                    //removing the marker from the modded index
                    self.markers[index].map = nil
                    
                    //assigning the new data to the modded index
                    self.trashModelArray[index] = data!
                    print("After change ->>> \(self.trashModelArray[index])")
                    
                    //plotting the new marker
                    let position = CLLocationCoordinate2D(latitude: self.trashModelArray[index].lat, longitude: self.trashModelArray[index].lon)
                    let trashType = self.trashModelArray[index].trash_type
                    let isMeetupScheduled = self.trashModelArray[index].is_meetup_scheduled
                    let expirationTime = self.helper.minuteParameter(for: self.trashModelArray[index].expiration_date)
                    
                    let marker = self.assignAMarkerIcon(for: position, on: trashType, and: isMeetupScheduled)
                    let filledMarker = self.assignMarkerProperty(expirationTime: expirationTime, isMeetupScheduled: isMeetupScheduled, marker: marker)
                    
                    self.markers[index] = filledMarker
                    self.markers[index].map = self.mapView

                    print("TYPE MODDED ->>>")
                    
                }
            }
        }
        
    }
    
    func updateUserCurrentNeighborhood(forUser id:String, with neighborhood:String){
        db.collection("Users").document("\(id)").updateData([
            "neighborhood" : neighborhood
        ]) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
