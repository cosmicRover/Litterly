//
//  ScheduleAlertViewController.swift
//  Litterly
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
    var scheduleWeekdayNum:Int!
    var scheduleWeekdayText:String!
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
//        components.hour = +12
        let minDate = calender.date(byAdding: components, to: currentDate)!
        
        components.day = +7
        let maxDate = calender.date(byAdding: components, to: currentDate)
        
        
        meetupdatePicker.minimumDate = minDate
        meetupdatePicker.maximumDate = maxDate
        
        meetupdatePicker.minuteInterval = 30
        meetupdatePicker.addTarget(self, action: #selector(handleUiDatePicker), for: .valueChanged)
        
        let date = getFormattedDate(date: minDate)
        meetupDate = date as String
        print(meetupDate! as String)
        
        scheduleWeekdayNum = Calendar.current.component(.weekday, from: minDate)
        print("\(scheduleWeekdayNum as Int)")
        
        scheduleWeekdayText = convertNumToWeekday(on: scheduleWeekdayNum)
        print("\(scheduleWeekdayText as String)")
        
    }
    
    //gets the date and time selected by the user
    @objc func handleUiDatePicker(sender: UIDatePicker){
        
        let date = self.getFormattedDate(date: sender.date)
        meetupDate = date as String
        print(meetupDate! as String)
        
        //int associated with weekday
        scheduleWeekdayNum = Calendar.current.component(.weekday, from: sender.date)
        print("\(scheduleWeekdayNum as Int)")
        
        scheduleWeekdayText = convertNumToWeekday(on: scheduleWeekdayNum)
        print("\(scheduleWeekdayText as String)")
        
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
        var todayCount:Int!
        
        getMeetupDayCount(for: "\(self.sharedValue.currentUserEmail! as String)") { (count) in
            todayCount = count as! Int
            
            if todayCount == 10{
                self.dismiss(animated: true, completion: nil)//dismisses the schedule view
                print("You have exceeded the max of this day!")
                return
            }
            
            //we are looking for 10 or less markers within a ceratin radius to be appended to our scheduling array
            for marker in self.sharedValue.trashModelArrayBuffer{
                //if it's already 10, break immediately
                if loopCounter == (10 - todayCount){
                    break
                }
                
                //gets the distance between tapped marker and the other markers on the main marker array
                let distance = helper.findDistanceBetweenTwoMarkers(coordinate1Lat: self.sharedValue.tappedArrayElementDict.lat, coordinate1Lon: self.sharedValue.tappedArrayElementDict.lon, coordinate2Lat: marker.lat , coordinate2Lat: marker.lon)
                
                //if the distance and meetup property criteria match, append the marker
                if distance <= self.eligibleMarkerDistance && marker.is_meetup_scheduled == false{
                    toBeScheduledMarkers.append(marker)
                }
                
                //inc counter
                loopCounter += 1
            }
            
            print(toBeScheduledMarkers)
            self.dismiss(animated: true, completion: nil)//dismisses the schedule view
            
            if toBeScheduledMarkers.count == 0{
                print("no nearby markers")
                
                //calls for relisten of the radius
                //need to find a stable fix
                NotificationCenter.default.post(name: NSNotification.Name("zeroMarkerCountTempFix"), object: nil)
                
                ///****Current bug***
                //if pressed info window once and it can't be scheduled,
                //user cant tap again to reschedule again*******
                
//                let mapVc = MapsViewController()
//                mapVc.listenForRadius()
                
                //this is an error since the tapped marker itself should be appended
            } else{
                
                //loop to go through all the eligible markers
                for marker in toBeScheduledMarkers{
                    dispatcher.enter()
                    // setting up the data
                    let meetupId:String = ("\(marker.lat)\(marker.lon)meetup")
                    let markerId:String = ("\(marker.lat)\(marker.lon)marker")
                    let geofenceId:String = "\(self.sharedValue.currentUserEmail! as String)"
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
                                let dict:MeetupDataModel = MeetupDataModel(marker_lat: marker.lat, marker_lon: marker.lon, meetup_address: marker.street_address, meetup_date_time: "\(self.meetupDate! as String)", type_of_trash: marker.trash_type, author_id: "\(self.sharedValue.currentUserEmail! as String)", author_display_name: self.sharedValue.currentUserDisplayName! as String, confirmed_users: [["user_id" : "\(self.sharedValue.currentUserEmail! as String)", "user_pic_url" : "\(self.sharedValue.currentUserProfileImageURL! as String)"]], confirmed_users_ids: ["\(self.sharedValue.currentUserEmail! as String)"], meetup_day: "\(self.scheduleWeekdayText as String)")
                                
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
                let geofenceId:String = "\(self.sharedValue.currentUserEmail! as String)"
                let geofenceDocRef = self.db.collection("GeofenceData").document("\(geofenceId)")
                self.batch.updateData(
                    ["\(self.scheduleWeekdayText as String)_count" :
                    todayCount + toBeScheduledMarkers.count],
                    forDocument: geofenceDocRef)
                
                //notify the main thread that the batch data sets is ready
                dispatcher.notify(queue: .main) {
                    print("loop finished")
                    self.commitTheBatch()
                }
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
    

}
