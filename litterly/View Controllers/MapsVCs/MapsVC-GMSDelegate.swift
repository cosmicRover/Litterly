//
//  MapsVC-GMSDelegate.swift
//  litterly
//
//  Created by Joy Paul on 5/1/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation


extension MapsViewController: GMSMapViewDelegate{
    
    func findTheIndex(with lat:Double, and lon:Double) ->Int{
        let index = trashModelArray.firstIndex{$0.lat == lat && $0.lon == lon}
        print("tapped lat+lon index ->> \(index! as Int)")
        
        return index!
    }
    
    //gets lat and lon for tapped marker
    //configures a new marker and it's info window
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("tapped on marker with lat: \(marker.position.latitude)")
        print("tapped on marker with lon: \(marker.position.longitude)")
        
        tappedMarker = marker.position
        let index = findTheIndex(with: tappedMarker.latitude, and: tappedMarker.longitude)
        tappedArrayElement = trashModelArray[index]
        
        //passing the data to the singleton
        let value = SharedValues.sharedInstance
        value.tappedArrayElementDict = trashModelArray[index]
        
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        if tappedArrayElement.is_meetup_scheduled == false{
            setupViewForUnscheduled()
            unScheduledMarkerInfoWindow.center = mapView.projection.point(for: position)
            mapView.addSubview(unScheduledMarkerInfoWindow)
        }else if tappedArrayElement.is_meetup_scheduled == true{
            setupViewForScheduled()
            scheduledMarkerInfoWindow.center = mapView.projection.point(for: position)
            mapView.addSubview(scheduledMarkerInfoWindow)
        }
        
        return false
    }
    
    //returns a UIView that we will customize and add to subView
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    //sets up for unscheduled info Window
    func setupViewForUnscheduled(){
        unScheduledMarkerInfoWindow.layer.backgroundColor = UIColor.mainBlue.cgColor
        unScheduledMarkerInfoWindow.layer.cornerRadius = 12
        unScheduledMarkerInfoWindow.titleLabel.textColor = UIColor.textWhite
        unScheduledMarkerInfoWindow.userActionButton.backgroundColor = UIColor.trashOrange
        unScheduledMarkerInfoWindow.userActionButton.layer.cornerRadius = 12
        
    }
    
    func setupViewForScheduled(){
        scheduledMarkerInfoWindow.layer.backgroundColor = UIColor.mainBlue.cgColor
        scheduledMarkerInfoWindow.layer.cornerRadius = 12
        scheduledMarkerInfoWindow.titleLabel.textColor = UIColor.textWhite
        scheduledMarkerInfoWindow.userActionButton.backgroundColor = UIColor.mainGreen
        scheduledMarkerInfoWindow.userActionButton.layer.cornerRadius = 12
    }
    
    //onTap on mapView remove the custom info view from superview
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        unScheduledMarkerInfoWindow.removeFromSuperview()
        scheduledMarkerInfoWindow.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker
        if position != nil{
            //controling the spped of the view popping in with the animation
            if tappedArrayElement.is_meetup_scheduled == false{
                scheduledMarkerInfoWindow.removeFromSuperview()
                UIView.animate(withDuration: 0.10, delay: 0, options: .showHideTransitionViews, animations: {
                    self.unScheduledMarkerInfoWindow.center = mapView.projection.point(for: position!)
                    self.unScheduledMarkerInfoWindow.center.y -= 100
                }, completion: nil)
            } else if tappedArrayElement.is_meetup_scheduled == true{
                unScheduledMarkerInfoWindow.removeFromSuperview()
                UIView.animate(withDuration: 0.10, delay: 0, options: .showHideTransitionViews, animations: {
                    self.scheduledMarkerInfoWindow.center = mapView.projection.point(for: position!)
                    self.scheduledMarkerInfoWindow.center.y -= 100
                }, completion: nil)
            }
            
        }
    }
}
