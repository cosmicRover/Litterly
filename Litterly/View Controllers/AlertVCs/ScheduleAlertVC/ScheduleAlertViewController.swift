//
//  ScheduleAlertViewController.swift
//  Litterly
//
//  Created by Joy Paul on 5/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ScheduleAlertViewController: UIViewController{
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var organicButton: UIButton!
    @IBOutlet weak var plasticButton: UIButton!
    @IBOutlet weak var metalButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var meetupdatePicker: UIDatePicker!
    @IBOutlet weak var pickerParentView: UIView!
    @IBOutlet weak var uiPickerView: UIPickerView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    let cornerRadius:CGFloat = 12.0
    var scheduleWeekdayNum:Int!
    var scheduleWeekdayText:String!
    let alertService = AlertService()
    let sharedValue = SharedValues.sharedInstance
    let db = Firestore.firestore()
    let eligibleMarkerDistance = 10.0 //meters
    var batch = Firestore.firestore().batch()
    let helper = HelperFunctions()
    var localTimeZone: String {
        return TimeZone.current.abbreviation() ?? "unknown"
    }
    var UTCMeetupDate:Double!
    var nextSevenDays:[String] = []
    var meetupTimes:[String] = ["7 AM", "8 AM", "9 AM", "10 AM",
                                "11 AM", "12 PM", "1 PM", "2 PM",
                                "3 PM", "4 PM", "5 PM", "6 PM", "7 PM"]
    var finalMeetupString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerParentView.isUserInteractionEnabled = false //diabling it before getting the data ready
        generateNextSixDays()
        
        uiPickerView.dataSource = self
        uiPickerView.delegate = self
        
        roundsCorners()
        configuresColors()
    }
    

    func roundsCorners(){
        parentView.layer.cornerRadius = cornerRadius
        organicButton.layer.cornerRadius = cornerRadius
        plasticButton.layer.cornerRadius = cornerRadius
        metalButton.layer.cornerRadius = cornerRadius
        cancelButton.layer.cornerRadius = cornerRadius
        createButton.layer.cornerRadius = cornerRadius
        cameraButton.layer.cornerRadius = cornerRadius
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
        selectedButtonColor(selected: GlobalValues.tappedArrayElementDict.trash_type)
        createButton.backgroundColor = UIColor.mainGreen
        cancelButton.backgroundColor = UIColor.unselectedGrey
        pickerParentView.backgroundColor = UIColor.mainBlue
        cameraButton.backgroundColor = UIColor.unselectedGrey
    }
    
    
    @IBAction func onCameraButtonTap(_ sender: UIButton) {
        print("camera button tapped")
        //let user upload a photo
    }
    
    
    @IBAction func onCancelTap(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //on createTap, schedule a meetup and update the marker's meetup property
    @IBAction func onCreateTap(_ sender: UIButton) {
    
        var toBeScheduledMarkers = [TrashDataModel]()
        let dispatcher = DispatchGroup()
        var loopCounter = 0
        var todayCount:Int!
        
        getMeetupDayCount(for: "\(GlobalValues.currentUserEmail! as String)") { (count) in
            todayCount = count
            
            if todayCount == 10{
                self.dismiss(animated: true, completion: nil)//dismisses the schedule view
                print("You have exceeded the max of this day!")
                return
            }
            
            //we are looking for 10 or less markers within a ceratin radius to be appended to our scheduling array
            for marker in GlobalValues.trashModelArrayBuffer{
                //if it's already 10, break immediately
                if loopCounter == (10 - todayCount){
                    break
                }
                
                //gets the distance between tapped marker and the other markers on the main marker array
                let distance = self.helper.findDistanceBetweenTwoMarkers(coordinate1Lat: GlobalValues.tappedArrayElementDict.lat, coordinate1Lon: GlobalValues.tappedArrayElementDict.lon, coordinate2Lat: marker.lat , coordinate2Lat: marker.lon)
                print("marker append loop gets called")
                
                //*********** LOOP EXITS BEFORE GETTING ALL THE MARKERS THAT ARE QUALIFIED TO BE SCHEDULED *********
                //if the distance and meetup property criteria match, append the marker
                if distance <= self.eligibleMarkerDistance && marker.is_meetup_scheduled == false{
                    print("DISTANCE AND MARKER -> ", distance, marker)
                    toBeScheduledMarkers.append(marker)
                }
                
                
                //inc counter
                loopCounter += 1
            }
            
            print(toBeScheduledMarkers)
            print("TAPPED ELEMENT -> ", GlobalValues.tappedArrayElementDict as TrashDataModel)
            print("TRASH MODEL ARRAY CHUNK -> ", GlobalValues.trashModelArrayBuffer as [TrashDataModel])
            self.dismiss(animated: true, completion: nil)//dismisses the schedule view
            
            if toBeScheduledMarkers.count == 0{
//                print(todayCount as! Int)
//                print("no nearby markers")
                //this is an error since the tapped marker itself should be appended
            } else{
                
                //loop to go through all the eligible markers
                for marker in toBeScheduledMarkers{
                    dispatcher.enter()
                    // setting up the data
                    let meetupId:String = ("\(marker.lat)\(marker.lon)meetup")
                    let markerId:String = ("\(marker.lat)\(marker.lon)marker")
                    let geofenceId:String = "\(GlobalValues.currentUserEmail! as String)"
                    let meetupDocRef = self.db.collection("Meetups").document("\(meetupId)")
                    let markerDocRef = self.db.collection("TaggedTrash").document("\(markerId)")
                    let geofenceDocRef = self.db.collection("GeofenceData").document("\(geofenceId)")
                    
                    //checks if the document already exists. If not, proceed with the batch preparation
                    meetupDocRef.getDocument { (document, error) in
                        if let document = document {
                            if document.exists{
                                //show alert saying marker already exists
                                print("data already exists")
                                
                            } else {
                                //data prep
                                let dict:MeetupDataModel = MeetupDataModel(marker_lat: marker.lat, marker_lon: marker.lon, meetup_address: marker.street_address, meetup_date_time: "\(self.finalMeetupString! as String)", meetup_id: meetupId, parent_marker_id: markerId, type_of_trash: marker.trash_type, author_id: "\(GlobalValues.currentUserEmail! as String)" , author_display_name: GlobalValues.currentUserDisplayName! as String, confirmed_users: [["user_id" : "\(GlobalValues.currentUserEmail! as String)", "user_pic_url" : "\(GlobalValues.currentUserProfileImageURL! as String)"]], confirmed_users_ids: ["\(GlobalValues.currentUserEmail! as String)"], meetup_timezone: self.localTimeZone, UTC_meetup_time_and_expiration_time: self.UTCMeetupDate,  meetup_day: "\(self.scheduleWeekdayText as String)")
                                
                                //batch prep
                                self.batch.setData(dict.dictionary, forDocument: meetupDocRef)
                                self.batch.updateData(["is_meetup_scheduled": true], forDocument: markerDocRef)
                                
                                self.batch.updateData([
                                    "\(self.scheduleWeekdayText as String)" : FieldValue.arrayUnion([["lat" : marker.lat as Double, "lon" : marker.lon as Double]])], forDocument: geofenceDocRef)
                                
                                print("setting batches...")
                                dispatcher.leave()
                                print("right under dispatcher")
                            }
                        }
                    }
                }
                
                //update the day's count
                let geofenceId:String = "\(GlobalValues.currentUserEmail! as String)"
                let geofenceDocRef = self.db.collection("GeofenceData").document("\(geofenceId)")
                self.batch.updateData(
                    ["\(self.scheduleWeekdayText as String)_count" :
                    todayCount + toBeScheduledMarkers.count],
                    forDocument: geofenceDocRef)
                
                //notify the main thread that the batch data sets is ready
                dispatcher.notify(queue: .main) {
                    print("loop finished")
                    self.commitTheBatch(for: self.batch)
                    //uploading the fcm key, if it hasnt already uploaded
                    self.helper.checkIfNotificationPermissionWasGiven()
                }
            }
        }
            
    }
}
