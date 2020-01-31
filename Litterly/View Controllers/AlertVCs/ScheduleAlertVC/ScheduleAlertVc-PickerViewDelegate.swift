//
//  ScheduleAlertVc-PickerViewDelegate.swift
//  Litterly
//
//  Created by Joy Paul on 11/13/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import UIKit

extension ScheduleAlertViewController: UIPickerViewDataSource, UIPickerViewDelegate{
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
}
