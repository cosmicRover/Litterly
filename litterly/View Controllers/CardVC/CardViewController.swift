//
//  CardViewController.swift
//  Litterly
//
//  Created by Joy Paul on 4/8/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import Geofirestore
import GoogleMaps

class CardViewController: UIViewController {

    //all the outlets for the cardView controller
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var cardViewArea: UIView!
    @IBOutlet weak var LitterlySign: UILabel!
    @IBOutlet weak var nearbySign: UILabel!
    @IBOutlet weak var nearbySignSubTitle: UILabel!
    @IBOutlet weak var nearByCount: UILabel!
    @IBOutlet weak var trashType1: UIButton!
    @IBOutlet weak var trashType2: UIButton!
    @IBOutlet weak var trashType3: UIButton!
    @IBOutlet weak var reportTrashButton: UIButton!
    
    let db = Firestore.firestore()
    let trashTypes: [String] = ["organic", "plastic", "metal"]
    var submitTrashType: String!
    var trashModelArray = [TrashDataModel]()
    let firestoreCollection = Firestore.firestore().collection("TaggedTrash")
    var geoFirestore:GeoFirestore!
    let alertService = AlertService()
    let helper = HelperFunctions()
    var localTimeZone: String {
        return TimeZone.current.abbreviation() ?? "unknown"
    }
    var cameraView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpWidgetColors()
        roundButtonCorners()
        reportTrashButton.isEnabled = false
        
        geoFirestore = GeoFirestore(collectionRef: firestoreCollection)
    }
    

    //rounds the button's corners
    func roundButtonCorners(){
        let roundValue = CGFloat(12.0)
        
        trashType1.layer.cornerRadius = roundValue
        trashType2.layer.cornerRadius = roundValue
        trashType3.layer.cornerRadius = roundValue
        reportTrashButton.layer.cornerRadius = roundValue
    }
    
    //sets up all the widgets with their corresponding colors
    func setUpWidgetColors(){
        handleArea.backgroundColor = UIColor.mainBlue
        cardViewArea.backgroundColor = UIColor.mainBlue
        nearbySign.textColor = UIColor.textWhite
        nearbySignSubTitle.textColor = UIColor.textWhite
        nearByCount.textColor = UIColor.mainGreen
        LitterlySign.textColor = UIColor.textWhite
        trashType1.backgroundColor = UIColor.unselectedGrey
        trashType2.backgroundColor = UIColor.unselectedGrey
        trashType3.backgroundColor = UIColor.unselectedGrey
        reportTrashButton.backgroundColor = UIColor.mainGreen
    }
    
    //the trash type buttons, user must select one
    @IBAction func trashType1ButtonOnTap(_ sender: UIButton) {
        trashType1.isSelected = !trashType1.isSelected
        trashType2.isSelected = false
        trashType3.isSelected = false
        if trashType1.isSelected == true{
            reportTrashButton.isEnabled = true
            submitTrashType = trashTypes[0]
        } else{
            reportTrashButton.isEnabled = false
        }
    }
    
    @IBAction func trashType2ButtonOnTap(_ sender: SelectedButton) {
        trashType2.isSelected = !trashType2.isSelected
        trashType1.isSelected = false
        trashType3.isSelected = false
        if trashType2.isSelected == true{
            reportTrashButton.isEnabled = true
            submitTrashType = trashTypes[1]
        } else{
            reportTrashButton.isEnabled = false
        }
    }
    
    @IBAction func trashType3ButtonOnTap(_ sender: SelectedButton) {
        trashType3.isSelected = !trashType3.isSelected
        trashType1.isSelected = false
        trashType2.isSelected = false
        if trashType3.isSelected == true{
            reportTrashButton.isEnabled = true
            submitTrashType = trashTypes[2]
        } else{
            reportTrashButton.isEnabled = false
        }
    }
    
    func deselectAllTrashTypeButtons(){
        trashType1.isSelected = false
        trashType2.isSelected = false
        trashType3.isSelected = false
    }
    
    func hideExistingUiElements(){
        self.LitterlySign.isHidden = true
        self.trashType1.isHidden = true
        self.trashType3.isHidden = true
        self.reportTrashButton.isHidden = true
    }
    
    //func that will request lat, lon, trash type in order to got to the next steps of reporting trash
    @IBAction func reportTrashButtonOnTap(_ sender: UIButton) {
        print("report trash tapped!!")
        let height = self.view.frame.height
        let width = self.view.frame.width
        let trashType = self.submitTrashType
        let timezone = self.localTimeZone

        let cameraVC = CameraViewController(height: Double(height), width: Double(width), trashType: trashType!, timezone: timezone)
        
        self.view.addSubview(cameraVC.view)
        self.addChild(cameraVC)
        cameraVC.didMove(toParent: self)
    }
}
