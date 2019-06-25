//
//  CardVC-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 5/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import Geofirestore

extension CardViewController{
    //adds document to firestore
    func submitTrashToFirestore(with dictionary: [String:Any], for id:String){
        
        db.collection("TaggedTrash").document("\(id)").setData(dictionary) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
        }
        
    }
    
    //updates neighborhood on each tag
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
    //**************EXPERIMENTS*****************
    
    func setLocationWithGeoFirestore(for id:String, on location:CLLocationCoordinate2D){
        
        let cllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geoFirestore.setLocation(location: cllocation, forDocumentWithID: "\(id)") { (error) in
            if let error = error {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
    }
}
