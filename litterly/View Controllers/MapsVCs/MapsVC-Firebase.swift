//
//  MapsVC-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 4/26/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//
import UIKit
import GoogleMaps
import CoreLocation
import FirebaseFirestore
import Geofirestore

extension MapsViewController{
    
    //returns a custom map marker based on trashType
    func giveMeAMarker(for location:CLLocationCoordinate2D, on trashType:String, and isMeetupScheduled:Bool) -> GMSMarker{
        
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
        ////USE geofirestore to pass parameter and query!!!
        
       self.realTimeListener =  db.collection("TaggedTrash").whereField("id", isEqualTo: "\(id)")
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
                    let marker = self.giveMeAMarker(for: position, on: trashType, and: isMeetupScheduled)

                    marker.opacity = 0.8
                    //appends to marker tracking array
                    self.markers.append(marker)
                    marker.appearAnimation = .pop
                    marker.map = self.mapView
                    
                    print("TYPE ADDED->> \(diff.document.data())")
                    
                    //if removed (when a clean up is complete, add a ghost trail of the previous marker
                } else if diff.type == .removed{
                    
                   //gotta handle remove event responsibly
                    //reload both of the arrays??
                    
                    
                  
                    
                    //or modified an existing one (when a cleanup is scheduled)
                } else if diff.type == .modified{
                    
                    //self.oldTappedArrayElement = self.tappedArrayElement
                    
                    let data = TrashDataModel(dictionary: diff.document.data())
                    //gets the index of the modded data with the lat and long
                    let index = self.findTheIndex(with: data!.lat, and: data!.lon)
                    
                    //assigning a reference to the modded data
                    self.justModdedArrayElement = data
                    //and then posting a notification
                    //NotificationCenter.default.post(name: NSNotification.Name("tappedArrayElement-reloaded"), object: nil)
                    
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
                    
                    let marker = self.giveMeAMarker(for: position, on: trashType, and: isMeetupScheduled)
                    
                    marker.opacity = 0.8
                    marker.appearAnimation = .pop
                    self.markers[index] = marker
                    self.markers[index].map = self.mapView

                    print("TYPE MODDED ->>>")
                    
                }
            }
        }
    }
    
    ////**************EXPERIMENTS

    func queryForNearby(center centerCamera:CLLocationCoordinate2D, with circleRadius:Double, completionHandler: @escaping ([String]?) -> ()) {
        
        let center = CLLocation(latitude: centerCamera.latitude, longitude: centerCamera.longitude)
        print(center)
        
        var idArray = [String]()
        
        self.circleQuery = geoFirestore.query(withCenter: center, radius: circleRadius) ///*** fatal crash
        
        self.isCircleQueryListening = true
        
        circleQuery.observeReady {
            
            self.isNearbyHanle = self.circleQuery.observe(.documentEntered, with: {(id, location) in
                print("****************************************\(id! as String) is nearby")
                idArray.append("\(id! as String)")
                //self.realTimeMarkerListener(documentId: "\(id! as String)")
                
                //need to remove the listeners or duplicate values will be generated
                
            })
            
            self.hasLeftNearby = self.circleQuery.observe(.documentExited, with: {(id, location) in
                print("****************************************\(id! as String) has left nearby")
                
            })
            
            self.hasDocumentMoved = self.circleQuery.observe(.documentMoved, with: {(id, location) in
                print("****************************************\(id! as String) has been moved")
                //self.fetchNearbyMarkers(with: id!)
                
            })
         
            completionHandler(idArray as [String])
        }
//        circleQuery.removeObserver(withHandle: self.isNearbyHanle)
//        circleQuery.removeObserver(withHandle: self.hasLeftNearby)
//        circleQuery.removeObserver(withHandle: self.hasDocumentMoved)
        
    }
    
    func fetchNearbyMarkers(with id:String){
        let query = db.collection("TaggedTrash").whereField("id", isEqualTo: "\(id)")
        
        query.getDocuments(){
            QuerySnapshot, Error in
            
            //self.userTaggedTrash = (QuerySnapshot!.documents.compactMap({TrashDataModel(dictionary: $0.data())}))
            
            guard let snapShot = QuerySnapshot else {return}
            
            snapShot.documents.forEach{
                data in
                
                let x = data.data()["street_address"]
                
                print(x as! String)
                
            }

        }

    }
    
}
