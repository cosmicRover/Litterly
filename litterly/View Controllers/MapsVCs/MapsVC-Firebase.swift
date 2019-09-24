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
                    
                    let position = CLLocationCoordinate2D(latitude: self.trashModelArray.last!.lat, longitude: self.trashModelArray.last!.lon)
                    let trashType = self.trashModelArray.last!.trash_type
                    let marker = self.assignAMarkerIcon(for: position, on: trashType, and: isMeetupScheduled)

                    marker.opacity = 0.8
                    //appends to marker tracking array
                    self.markers.append(marker)
                    marker.appearAnimation = .pop
                    marker.map = self.mapView
                    
                    print("TYPE ADDED->> \(diff.document.data())")
                    
                    //if removed (when a clean up is complete, add a ghost trail of the previous marker
                } else if diff.type == .removed{
                    
                    print("------------>>>> REMOVE TRIGGERED")
                    
                    //gotta find a way that is not to obtuse for users to get new data
                    //self.listenForRadius()
                    
                    print("REMOVED DATA ---->> \(diff.document.data())")
                    
                    //**** experimental
                    let data = TrashDataModel(dictionary: diff.document.data())
//
                    let index = self.findTheIndexOnTrashModelArrAndMarkers(with: data!.lat, and: data!.lon)

                    let mockData = TrashDataModel(id: "removed", author: "removed", lat: 999999, lon: 999999, trash_type: "removed", street_address: "removed", is_meetup_scheduled: false)
//
//                    self.trashModelArray[index] = mockData
                    self.markers[index].map = nil
                    //**** experimental
                    
                    //*****below solution sometimes produce nil********
                    //**cant remove an index that doesnt exist. only if ther
                    //takes the diif that was removed, finds the index of it
                    //then makes the marker dissapear from map, then removes the
                    //data from markers + trashModel array
//                    let data = TrashDataModel(dictionary: diff.document.data())
//                    print(diff.document.data())
//                    let index = self.findTheIndexWithId(with: id)
//
//                    self.markers[index].map = nil
//                    self.markers.remove(at: index)
//                    self.trashModelArray.remove(at: index)
//
//                    let id = data?.id
//                    let nearbyIndex = self.findTheIndexOnNearbyMarkers(with: id!)
//                    self.nearbyIdsAndTheirDistanceFromUser.remove(at: nearbyIndex)
                    
                    //**** experimental
                    
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
                    NotificationCenter.default.post(name: NSNotification.Name("tappedArrayElement-reloaded"), object: nil)
                    
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
                    
                    let marker = self.assignAMarkerIcon(for: position, on: trashType, and: isMeetupScheduled)
                    
                    marker.opacity = 0.8
                    marker.appearAnimation = .pop
                    self.markers[index] = marker
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
