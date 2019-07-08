//
//  ScheduleAlertViewController.swift
//  litterly
//
//  Created by Joy Paul on 5/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ScheduleAlertViewController: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var organicButton: UIButton!
    @IBOutlet weak var plasticButton: UIButton!
    @IBOutlet weak var metalButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var meetupdatePicker: UIDatePicker!
    
    let cornerRadius:CGFloat = 12.0
    let alertService = AlertService()
    let sharedValue = SharedValues.sharedInstance
    var meetupDate:String!
    let db = Firestore.firestore()
    let eligibleMarkerDistance = 50.0 //meters
    var batch = Firestore.firestore().batch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundsCorners()
        configuresColors()
        setupUiDatePicker()
    }
    
    //sets up the datePicker with proper date + time configuration
    func setupUiDatePicker(){
        let calender = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calender
        
        components.day = +1
        components.hour = +12
        let minDate = calender.date(byAdding: components, to: currentDate)!
        meetupdatePicker.minimumDate = minDate
        meetupdatePicker.addTarget(self, action: #selector(handleUiDatePicker), for: .valueChanged)
        
        let date = getFormattedDate(date: minDate)
        meetupDate = date as String
        print(meetupDate! as String)
        
    }
    
    //gets the date and time selected by the user
    @objc func handleUiDatePicker(sender: UIDatePicker){
        
        let date = self.getFormattedDate(date: sender.date)
        meetupDate = date as String
        print(meetupDate! as String)
    }
    
    //returns a formatted date when given an input
    func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeStyle = DateFormatter.Style.short
        let formattedDateAndTime = dateFormatter.string(from: date)
        
        return formattedDateAndTime as String
    }

    func roundsCorners(){
        parentView.layer.cornerRadius = cornerRadius
        organicButton.layer.cornerRadius = cornerRadius
        plasticButton.layer.cornerRadius = cornerRadius
        metalButton.layer.cornerRadius = cornerRadius
        cancelButton.layer.cornerRadius = cornerRadius
        createButton.layer.cornerRadius = cornerRadius
    }
    
    //decides which button to color orange
    func selectedButtonColor(selected type:String){
        switch type {
        case "organic":
            organicButton.backgroundColor = UIColor.trashOrange
            plasticButton.backgroundColor = UIColor.unselectedGrey
            metalButton.backgroundColor = UIColor.unselectedGrey
            break
        case "plastic":
            organicButton.backgroundColor = UIColor.unselectedGrey
            plasticButton.backgroundColor = UIColor.trashOrange
            metalButton.backgroundColor = UIColor.unselectedGrey
            break
            
        case "metal":
            organicButton.backgroundColor = UIColor.unselectedGrey
            plasticButton.backgroundColor = UIColor.unselectedGrey
            metalButton.backgroundColor = UIColor.trashOrange
            break
        default:
            organicButton.backgroundColor = UIColor.unselectedGrey
            plasticButton.backgroundColor = UIColor.unselectedGrey
            metalButton.backgroundColor = UIColor.unselectedGrey
        }
    }
    
    func configuresColors(){
        self.view.backgroundColor = UIColor.unselectedGrey.withAlphaComponent(0.35)
        parentView.backgroundColor = UIColor.mainBlue
        selectedButtonColor(selected: sharedValue.tappedArrayElementDict.trash_type)
        createButton.backgroundColor = UIColor.mainGreen
        cancelButton.backgroundColor = UIColor.unselectedGrey
        meetupdatePicker.setValue(UIColor.textWhite, forKey: "textColor")
    }

    
    @IBAction func onCancelTap(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //on createTap, schedule a meetup and update the marker's meetup property
    @IBAction func onCreateTap(_ sender: UIButton) {
        
        let helper = HelperFunctions()
        var toBeScheduledMarkers = [TrashDataModel]()
        let dispatcher = DispatchGroup()
        
        var loopCounter = 0
        
        //we are looking for 20 or less markers within a ceratin radius to be appended to our scheduling array
        for marker in sharedValue.trashModelArrayBuffer{
            //if it's already 20, break immediately
            if loopCounter == 20{
                break
            }
            
            //gets the distance between tapped marker and the other markers on the main marker array
            let distance = helper.findDistanceBetweenTwoMarkers(coordinate1Lat: sharedValue.tappedArrayElementDict.lat, coordinate1Lon: sharedValue.tappedArrayElementDict.lon, coordinate2Lat: marker.lat , coordinate2Lat: marker.lon)
            
            //if the distance and meetup property criteria match, append the marker
            if distance <= eligibleMarkerDistance && marker.is_meetup_scheduled == false{
                toBeScheduledMarkers.append(marker)
            }
            
            //inc counter
            loopCounter += 1
        }
        
        print(toBeScheduledMarkers)
        self.dismiss(animated: true, completion: nil)//dismisses the schedule view
        
        if toBeScheduledMarkers.count == 0{
            print("no nearby markers")
            //this is an error since the tapped marker itself should be appended
        } else{
            
            //loop to go through all the eligible markers
            for marker in toBeScheduledMarkers{
                dispatcher.enter()
                // setting up the data
                let meetupId:String = ("\(marker.lat)\(marker.lon)meetup")
                let markerId:String = ("\(marker.lat)\(marker.lon)marker")
                let meetupDocRef = db.collection("Meetups").document("\(meetupId)")
                let markerDocRef = db.collection("TaggedTrash").document("\(markerId)")
                
                //checks if the document already exists. If not, proceed with the batch preparation
                meetupDocRef.getDocument { (document, error) in
                    if let document = document {
                        if document.exists{
                            //show alert saying marker already exists
                            print("data already exists")
                            
                        } else {
                            //data prep
                            let dict:MeetupDataModel = MeetupDataModel(marker_lat: marker.lat, marker_lon: marker.lon, meetup_address: marker.street_address, meetup_date_time: "\(self.meetupDate! as String)", type_of_trash: marker.trash_type, author_id: "\(self.sharedValue.currentUserEmail! as String)", author_display_name: self.sharedValue.currentUserDisplayName! as String, confirmed_users: [["user_id" : "\(self.sharedValue.currentUserEmail! as String)", "user_pic_url" : "\(self.sharedValue.currentUserProfileImageURL! as String)"]], confirmed_users_ids: ["\(self.sharedValue.currentUserEmail! as String)"])
                            
                            //batch prep
                            self.batch.setData(dict.dictionary, forDocument: meetupDocRef)
                            self.batch.updateData(["is_meetup_scheduled": true], forDocument: markerDocRef)
                            print("setting batches...")
                            dispatcher.leave()
                            print("right under dispatcher")
                        }
                    }
                }
            }
            
            //notify the main thread that the batch data sets is ready
            dispatcher.notify(queue: .main) {
                print("loop finished")
                self.commitTheBatch()
            }
        }
    }
    
    //commits the batch and then shows the success alert if everything went through
    func commitTheBatch(){
        batch.commit { (error) in
            if let error = error{
                print(error.localizedDescription)
                //show error alert
            }else{
                print("comitted batch")
                self.showSuccessAlert()
            }
        }
    }
    
    
    //display the checkmark animation
    func showSuccessAlert(){
        let alert = alertService.alertForGeneral()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    

}
