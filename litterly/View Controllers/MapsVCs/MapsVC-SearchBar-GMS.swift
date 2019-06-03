//
//  MapsVC-SearchBar-GMS.swift
//  litterly
//
//  Created by Joy Paul on 5/22/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

extension MapsViewController: GMSAutocompleteViewControllerDelegate{
    
    @objc func launchAutocomplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)

    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place lat: \(place.coordinate.latitude)")
        print("Place lon: \(place.coordinate.longitude)")
        
        getPlaceLatAndLot(for: "\(place.placeID! as String)")
        
        dismiss(animated: true, completion: nil)
    }
    
    //find a location's lat and lon using it's place id
    func getPlaceLatAndLot(for placeId:String){
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))!
        let client = GMSPlacesClient()
        
        client.fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print("The selected place is: \(place.coordinate)")
                self.animateToSearchedLocation(with: place.coordinate)
            }
        })
    }
    
    //animates the camera of the GMSView to a given coordinate
    func animateToSearchedLocation(with location:CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        self.mapView?.animate(to: camera)
    }

    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }    
    
}
