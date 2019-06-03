//
//  ScheduleAlertViewController.swift
//  litterly
//
//  Created by Joy Paul on 5/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

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
        let id:String = ("\(sharedValue.tappedArrayElementDict.lat)\(sharedValue.tappedArrayElementDict.lon)meetup")
        
        let dict:MeetupDataModel = MeetupDataModel(marker_lat: sharedValue.tappedArrayElementDict.lat, marker_lon: sharedValue.tappedArrayElementDict.lon, meetup_address: sharedValue.tappedArrayElementDict.street_address, meetup_date_time: "\(meetupDate! as String)", type_of_trash: sharedValue.tappedArrayElementDict.trash_type, author_id: "\(sharedValue.currentUserEmail! as String)", author_display_name: sharedValue.currentUserDisplayName! as String, confirmed_users: [["user_id" : "\(sharedValue.currentUserEmail! as String)", "user_pic_url" : "\(sharedValue.currentUserProfileImageURL! as String)"]])
        
        createAMeetup(with: dict.dictionary, for: "\(id)")
        //updating from device causes arrays to go bat-shit crazy
        updateMeetupProperty(for: "\(sharedValue.tappedArrayElementDict.id)", with: true)
        print(sharedValue.tappedArrayElementDict.id)
        //sharedValue.meetupDict = nil
        self.dismiss(animated: true, completion: showSuccessAlert)

    }
    
    func showSuccessAlert(){
        let alert = alertService.alertForGeneral()
        DispatchQueue.main.async {
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
