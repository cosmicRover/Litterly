//
//  JoinAlertVC-ValidateTimezone.swift
//  Litterly
//
//  Created by Joy Paul on 10/29/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
//TODO: verify timezone once datepicker had been finalized
extension JoinAlertViewController{
    func canUserJoin(UTCMeetupTime: Double) -> Bool{
        let currentUTCTime = Date().timeIntervalSince1970 + 86400 //increment current time by 24 hours
        print(currentUTCTime)
        if currentUTCTime < UTCMeetupTime{return true}
        else {return false}
    }
}
