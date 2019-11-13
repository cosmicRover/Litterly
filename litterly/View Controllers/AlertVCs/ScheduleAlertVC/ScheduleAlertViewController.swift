//
//  ScheduleAlertViewController.swift
//  Litterly
//
//  Created by Joy Paul on 5/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ScheduleAlertViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var organicButton: UIButton!
    @IBOutlet weak var plasticButton: UIButton!
    @IBOutlet weak var metalButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var meetupdatePicker: UIDatePicker!
    @IBOutlet weak var pickerParentView: UIView!
    @IBOutlet weak var uiPickerView: UIPickerView!
    
    
    let cornerRadius:CGFloat = 12.0
    var scheduleWeekdayNum:Int!
    var scheduleWeekdayText:String!
    let alertService = AlertService()
    let sharedValue = SharedValues.sharedInstance
//    var meetupDate:String!
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
    
    /*
     TODO:= Comment, cleanup and seprate the code
     need to update backend cloud functions as well
     */
    
    //generates the next seven days with day, month, date and year
    func generateNextSixDays(){
        let calender = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.calendar = calender
        
        let today = Date()
        print("today is --->>",DateFormatter.localizedString(from: today, dateStyle: .full, timeStyle: .none))
        
        //add two days to today and generate the next 6 days
        for x in 2...7{
            components.day = +x
            let nextDay = calender.date(byAdding: components, to: today)
            nextSevenDays.append(DateFormatter.localizedString(from: nextDay!, dateStyle: .medium, timeStyle: .none))
        }
        
        pickerParentView.isUserInteractionEnabled = true //enable pickerView after generation
        
        //setting up initial meetup string
        finalMeetupString = produceCompleteMeetupString(for: nextSevenDays[0], with: meetupTimes[0])
        print(finalMeetupString as String)
        
        let hour = determineHour(hour: 0)
        let formattedDate = getFormattedDate(day: 2, time: hour)
        print(formattedDate)
        getScheduledWeekDay(date: formattedDate)
        UTCMeetupDate = getFormattedDateToUTCDoubleValue(date: formattedDate)
        print("UTC TIME -->>", UTCMeetupDate as Double)
    }
    
    func returnScheduleView(){
        return self.dismiss(animated: true, completion: nil)
    }
    
    //each section on the pickerView is called a component. This one has two, date and time
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //return the component row height
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return nextSevenDays.count
        case 1:
            return meetupTimes.count
        default:
            fatalError()//this isn't supposed to happen
        }
    }
    
    //returns the data for the pickerViews with their default color modified
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch component {
        case 0:
            let coloredString = NSAttributedString(string: nextSevenDays[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.textWhite])
            return coloredString
        case 1:
            let attributedString = NSAttributedString(string: meetupTimes[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.textWhite])
            return attributedString
        default:
            fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let daysRow = pickerView.selectedRow(inComponent: 0)
        let timesRow = pickerView.selectedRow(inComponent: 1)
        
        finalMeetupString = produceCompleteMeetupString(for: nextSevenDays[daysRow], with: meetupTimes[timesRow])
        
        let hour = determineHour(hour: timesRow)
        let formattedDate = getFormattedDate(day: daysRow + 2, time: hour)
        print(formattedDate)
        getScheduledWeekDay(date: formattedDate)
        UTCMeetupDate = getFormattedDateToUTCDoubleValue(date: formattedDate)
        print("UTC TIME -->>", UTCMeetupDate as Double)
    }
    
    func determineHour(hour:Int) -> Int{
        let calender = Calendar(identifier: .gregorian)
        let date = Date()
        let currentHour = calender.component(.hour, from: date)
        
        print("currentHour ->", currentHour)
        
        return (hour + 7) - currentHour
    }
    
    func produceCompleteMeetupString(for day:String, with time:String) -> String {
        let completeString = "\(day) at \(time)"
        return completeString
    }
    
    //returns a formatted date when given a date String
    func getFormattedDate(day: Int, time: Int)-> Date {
        let calender = Calendar(identifier: .gregorian)
        let date = Date()
        var components = DateComponents()
        components.day = +day
        components.hour = +time
        
        let formattedDate = calender.date(byAdding: components, to: date)
        
        return formattedDate!
    }
    
    func getScheduledWeekDay(date:Date){
        let weekNum = Calendar.current.component(.weekday, from: date)
        scheduleWeekdayText = helper.convertNumToWeekday(on: weekNum)
    }
    
    //format time to UTC
    func getFormattedDateToUTCDoubleValue(date: Date) -> Double {
        let UTCTimeDoubleValue = date.timeIntervalSince1970
        return UTCTimeDoubleValue as Double
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
        selectedButtonColor(selected: GlobalValues.tappedArrayElementDict.trash_type)
        createButton.backgroundColor = UIColor.mainGreen
        cancelButton.backgroundColor = UIColor.unselectedGrey
        pickerParentView.backgroundColor = UIColor.mainBlue
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
