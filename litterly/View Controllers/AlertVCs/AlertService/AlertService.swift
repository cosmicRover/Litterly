//
//  AlertService.swift
//  litterly
//
//  Created by Joy Paul on 5/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class AlertService {
    
    func alertForSchedule() -> ScheduleAlertViewController{
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ScheduleAlertVC") as! ScheduleAlertViewController
        
        return alertVC
    }
    
    func alertForJoin() -> JoinAlertViewController{
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "JoinAlertVC") as! JoinAlertViewController
        
        return alertVC
    }
    
    func alertForGeneral() -> GeneralAlertViewController{
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "GeneralAlertVC") as! GeneralAlertViewController
        
        return alertVC
    }
}
